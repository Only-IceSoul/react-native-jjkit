package com.reactjjkit.image

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Outline
import android.os.Handler
import android.os.Looper
import android.util.Base64
import android.view.View
import androidx.appcompat.widget.AppCompatImageView
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.toBitmap
import androidx.core.graphics.drawable.toDrawable
import com.bumptech.glide.Glide
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.load.resource.gif.GifDrawable
import com.bumptech.glide.request.RequestListener
import com.bumptech.glide.request.RequestOptions
import com.bumptech.glide.request.target.Target
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.events.RCTEventEmitter
import java.lang.Exception
import java.lang.ref.WeakReference
import java.net.URL
import android.view.ViewOutlineProvider as ViewOutlineProvider1

class JJImageView(context: Context) : AppCompatImageView(context) {


    companion object{
        const val EVENT_ON_LOAD_START = "onLoadStart"
        const val EVENT_ON_LOAD_END = "onLoadEnd"
        const val EVENT_ON_LOAD_FAILED = "onLoadError"
        const val EVENT_ON_LOAD_SUCCESS = "onLoadSuccess"
    }

    init {
        clipToOutline = true
        outlineProvider = object: ViewOutlineProvider1(){
            override fun getOutline(view: View?, outline: Outline?) {
                outline?.setRoundRect(0,0,view!!.width,view.height,0f)
            }

        }
    }

    fun setSrc(data: ReadableMap?){
        if(data != null) {
            val w = data.getInt("width")
            val h = data.getInt("height")
            val cache = data.getBoolean("cache")
            val url = data.getString("uri")
            val asGif = data.getBoolean("asGif")
            val placeholder = data.getString("placeholder")

            if (url != null ) {
                val resize = w != -1 && h != -1
                val reqW = if (w > 20) w else 20
                val reqH = if (h > 20) h else 20
                updateImage(url,placeholder, cache, asGif,resize,reqW, reqH)
            }
        }
    }

    private fun updateImage(url:String,placeholder:String?,cache:Boolean,asGif:Boolean,resize:Boolean,reqW:Int,reqH:Int){
        val reactContext = WeakReference(context as ReactContext)
        Thread{
            val options = getOptions(asGif,cache,placeholder,resize,reqW,reqH)

            Handler(Looper.getMainLooper()).post{

                var manager  = if(asGif){
                    Glide.with(context).asGif()
                            .listener(object: RequestListener<GifDrawable> {
                                override fun onLoadFailed(e: GlideException?, model: Any?, target: Target<GifDrawable>?, isFirstResource: Boolean): Boolean {
                                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_FAILED, Arguments.createMap())
                                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_END, Arguments.createMap())
                                    return false
                                }

                                override fun onResourceReady(resource: GifDrawable?, model: Any?, target: Target<GifDrawable>?, dataSource: DataSource?, isFirstResource: Boolean): Boolean {
                                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_SUCCESS, Arguments.createMap())
                                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_END, Arguments.createMap())
                                    return false
                                }
                            })
                } else {
                    Glide.with(context)
                            .asBitmap()
                            .listener(object: RequestListener<Bitmap> {
                                override fun onLoadFailed(e: GlideException?, model: Any?, target: Target<Bitmap>?, isFirstResource: Boolean): Boolean {
                                    val mapFailed =  Arguments.createMap()
                                    mapFailed.putString("error",e?.message)
                                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_FAILED,mapFailed)
                                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_END, Arguments.createMap())
                                    return false
                                }

                                override fun onResourceReady(resource: Bitmap?, model: Any?, target: Target<Bitmap>?, dataSource: DataSource?, isFirstResource: Boolean): Boolean {
                                    val mapSuccess =  Arguments.createMap()
                                    mapSuccess.putInt("width",resource?.width ?: 0)
                                    mapSuccess.putInt("height",resource?.height ?: 0)
                                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_SUCCESS,mapSuccess)
                                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_END, Arguments.createMap())
                                    return false
                                }
                            })
                }
                when {
                    url.contains("base64,") -> {
                        val s = url.split(",")[1]
                        val bytes = android.util.Base64.decode(s,android.util.Base64.DEFAULT)
                        manager = manager.load(bytes)
                    }
                    url.contains("static;") -> {
                        val s = url.split("c;")[1]
                        manager = if(s.contains("http")) {
                            manager.load(s)
                        }else{
                            val id = context.resources.getIdentifier(s,"drawable", context.packageName)
                            manager.load(id)
                        }
                    }
                    else -> {
                        manager = manager.load(url)
                    }
                }


                reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_START, Arguments.createMap())
                manager.apply(options)
                        .into(this)
            }

            Thread.currentThread().interrupt()
        }.start()


    }


    private fun getOptions(asGif:Boolean,cache:Boolean,placeholder: String?,resize:Boolean,reqW:Int,reqH:Int):RequestOptions{
        var options = RequestOptions()
                .skipMemoryCache(cache)

        load(placeholder)?.toDrawable(context.resources)?.let {
            options = options.placeholder(it)
        }
        if(!asGif){
            options = options.frame(0L)
        }
        if(resize){
            options = options.fitCenter().override(reqW,reqH)
        }

        return options
    }

    private fun load(model: String?) : Bitmap? {
        if (model.isNullOrEmpty()) return null

        when {
            model.contains("base64,") -> {
                val s = model.split(",")[1]
                val bytes = Base64.decode(s, Base64.DEFAULT)
                val options =  BitmapFactory.Options()
                options.inMutable = true
                return BitmapFactory.decodeByteArray(bytes, 0, bytes.size, options)
            }
            model.contains("static;") -> {
                val s = model.split("c;")[1]
                return if(s.contains("http")) {
                    val url = URL(s)
                    return try{
                        BitmapFactory.decodeStream(url.openConnection().getInputStream())
                    }catch (e: Exception){
                        null
                    }
                }else{
                    val id = context.resources.getIdentifier(s,"drawable", context.packageName)
                    ContextCompat.getDrawable(context,id)?.toBitmap()
                }
            }
            else -> {
                return null
            }
        }

    }

}