package com.reactjjkit.image

import android.content.Context
import android.graphics.Outline
import android.view.View
import androidx.appcompat.widget.AppCompatImageView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.request.RequestOptions
import com.facebook.react.bridge.ReadableMap
import android.view.ViewOutlineProvider as ViewOutlineProvider1

class JJImageView(context: Context) : AppCompatImageView(context) {

    init {
        scaleType = ScaleType.CENTER_CROP
        clipToOutline = true
        outlineProvider = object: ViewOutlineProvider1(){
            override fun getOutline(view: View?, outline: Outline?) {
                outline?.setRoundRect(0,0,view!!.width,view.height,0f)
            }

        }
    }

    fun setData(data: ReadableMap?){
        if(data != null) {
            val w = data.getInt("width")
            val h = data.getInt("height")
            val cache = data.getBoolean("cache")
            val url = data.getString("url")
            val asGif = data.getBoolean("asGif")
            if (url != null ) {
                val reqW = if (w > 20) w else 20
                val reqH = if (h > 20) w else 20
                updateImage(url, cache, asGif, w, h, reqW, reqH)
            }
        }
    }

    private fun updateImage(url:String,cache:Boolean,asGif:Boolean,w:Int,h:Int,reqW:Int,reqH:Int){
        if (cache) {
            if (w != 1 && h != -1) {
                updateImageCache(url,asGif,reqW,reqH)
            }else {
                updateImageCache(url,asGif)
            }
        }else {
            if (w != 1 && h != -1)  {
                updateImageNoCache(url,asGif,reqW,reqH)
            }else {
                updateImageNoCache(url,asGif)
            }
        }
    }


    private fun updateImageCache(url:String,asGif:Boolean,w:Int,h:Int){
        if (asGif ){
            val options =  RequestOptions()
                    .fitCenter()
                    .override(w, h)
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
            Glide.with(context).asGif().load(url).apply(options).into(this)

        }else{
            val options =  RequestOptions()
                    .frame(0L)
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .fitCenter()
                    .override(w, h)
            Glide.with(context).load(url)
                    .apply(options)
                    .into(this)
        }

    }

    private fun updateImageCache(url:String,asGif: Boolean){
        if (asGif){
            val options =  RequestOptions()
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
            Glide.with(context).asGif().load(url).apply(options).into(this)
        }else{
            val options =  RequestOptions()
                    .frame(0L)
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
            Glide.with(context).load(url)
                    .apply(options)
                    .into(this)
        }
    }

    private fun updateImageNoCache(url:String,asGif: Boolean,w:Int,h:Int){
        if (asGif){
            val options =  RequestOptions().fitCenter().override(w, h)
                    .skipMemoryCache(true)
            Glide.with(context).asGif().load(url).apply(options).into(this)
        }else{
            val options =  RequestOptions()
                    .frame(0L)
                    .fitCenter()
                    .override(w, h)
                    .skipMemoryCache(true)
            Glide.with(context).load(url)
                    .apply(options)
                    .into(this)
        }
    }
    private fun updateImageNoCache(url:String,asGif: Boolean){
        if (asGif){
            val options =  RequestOptions()
                    .skipMemoryCache(true)
            Glide.with(context).asGif().load(url).apply(options).into(this)
        }else{
            val options =  RequestOptions()
                    .frame(0L)
                    .skipMemoryCache(true)
            Glide.with(context).load(url)
                    .apply(options)
                    .into(this)
        }
    }
}