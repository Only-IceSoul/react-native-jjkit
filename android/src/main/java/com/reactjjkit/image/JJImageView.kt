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
import com.bumptech.glide.Priority
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.load.model.GlideUrl
import com.bumptech.glide.load.model.LazyHeaders
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
        const val EVENT_ON_LOAD_ERROR = "onLoadError"
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
            val w = try {  data.getInt("width") }catch(e:Exception) {  -1 }
            val h = try { data.getInt("height") }catch(e:Exception) {  -1 }
            val skipMemoryCache =try { data.getBoolean("skipMemoryCache") }catch(e:Exception) { false }
            val diskCacheStrategy = try { data.getInt("diskCacheStrategy") }catch(e:Exception) { 0 }
            val uri =  try { data.getString("uri") } catch(e:Exception) { null }
            val asGif = try { data.getBoolean("asGif") }catch(e:Exception) { false }
            val placeholder = try { data.getString("placeholder") }catch(e:Exception) { null }
            val headers =  try { data.getMap("headers") } catch(e:Exception) { null }
            val prior =  try { data.getInt("priority") } catch(e:Exception) { 5 }
            val priority = if(prior <= 0) Priority.LOW else if(prior in 1..5) Priority.NORMAL else Priority.HIGH


            val resize = w != -1 && h != -1
            val reqW = if (w > 20) w else 20
            val reqH = if (h > 20) h else 20
            updateImage(uri,placeholder, skipMemoryCache,diskCacheStrategy, headers, priority,asGif,resize,reqW, reqH)

        }
    }

    private fun updateImage(url:String?, placeholder:String?, cache:Boolean,diskCacheStrategy:Int, headers:ReadableMap?, priority: Priority, asGif:Boolean, resize:Boolean, reqW:Int, reqH:Int){
        val reactContext = WeakReference(context as ReactContext)
        Thread{
            val options = getOptions(asGif,priority,cache,diskCacheStrategy,placeholder,resize,reqW,reqH)

            Handler(Looper.getMainLooper()).post{

                var manager  = if(asGif){
                    Glide.with(context).asGif()
                            .listener(object: RequestListener<GifDrawable> {
                                override fun onLoadFailed(e: GlideException?, model: Any?, target: Target<GifDrawable>?, isFirstResource: Boolean): Boolean {
                                    val mapFailed =  Arguments.createMap()
                                    mapFailed.putString("error",e?.message)
                                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_ERROR, mapFailed)
                                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_END, Arguments.createMap())
                                    return false
                                }

                                override fun onResourceReady(resource: GifDrawable?, model: Any?, target: Target<GifDrawable>?, dataSource: DataSource?, isFirstResource: Boolean): Boolean {
                                    val mapSuccess =  Arguments.createMap()
                                    mapSuccess.putInt("width",resource?.intrinsicWidth ?: 0)
                                    mapSuccess.putInt("height",resource?.intrinsicHeight ?: 0)
                                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_SUCCESS, mapSuccess)
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
                                    reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_ERROR,mapFailed)
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
                    url?.contains("base64,") == true -> {
                        val s = url.split(",")[1]
                        val bytes = android.util.Base64.decode(s,android.util.Base64.DEFAULT)
                        manager = manager.load(bytes)
                    }
                    url?.contains("static;") == true -> {
                        val s = url.split("c;")[1]
                        manager = if(s.contains("http")) {
                            manager.load(s)
                        }else{
                            val id = context.resources.getIdentifier(s,"drawable", context.packageName)
                            manager.load(id)
                        }
                    }
                    else -> {
                       
                        manager = if(headers != null){
                            val iterator = headers.keySetIterator()
                            val h = LazyHeaders.Builder()
                            while (iterator.hasNextKey()){
                                val key = iterator.nextKey()
                                val value = headers.getString(key) ?: ""
                                h.addHeader(key,value)
                            }
                            manager.load(GlideUrl(url,h.build()))
                        }else{
                            manager.load(url)
                        }
                    }
                }


                reactContext.get()?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(id, EVENT_ON_LOAD_START, Arguments.createMap())
                manager.apply(options)
                        .into(this)
            }

            Thread.currentThread().interrupt()
        }.start()


    }


    private fun getOptions(asGif:Boolean, priority: Priority, cache:Boolean,diskCacheStrategy:Int, placeholder: String?, resize:Boolean, reqW:Int, reqH:Int):RequestOptions{

        val ds = getDiskCacheStrategy(diskCacheStrategy)

        var options = RequestOptions()
                .skipMemoryCache(cache)
                .priority(priority)
                .diskCacheStrategy(ds)


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

    private fun getDiskCacheStrategy(strategy: Int): DiskCacheStrategy {
        return when(strategy){
            1 -> DiskCacheStrategy.NONE
            2 -> DiskCacheStrategy.ALL
            3 -> DiskCacheStrategy.DATA
            4 -> DiskCacheStrategy.RESOURCE
            else -> DiskCacheStrategy.AUTOMATIC
        }
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