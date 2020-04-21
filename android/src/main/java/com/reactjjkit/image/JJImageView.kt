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
            val type = data.getString("type")
            if (url != null && type != null) {
                val reqW = if (w > 20) w else 20
                val reqH = if (h > 20) w else 20
                updateImage(url, cache, type, w, h, reqW, reqH)
            }
        }
    }

    private fun updateImage(url:String,cache:Boolean,type:String,w:Int,h:Int,reqW:Int,reqH:Int){
            if (cache) {
                if (w != 1 && h != -1) {
                    updateImageCache(url,type,reqW,reqH)
                }else {
                    updateImageCache(url,type)
                }
            }else {
                if (w != 1 && h != -1)  {
                    updateImageNoCache(url,type,reqW,reqH)
                }else {
                    updateImageNoCache(url,type)
                }
            }
    }


    private fun updateImageCache(url:String,type:String,w:Int,h:Int){
        if(type == "image"){
            val options =  RequestOptions()
                    .fitCenter()
                    .override(w, h)
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
            Glide.with(context).load(url).apply(options).into(this)
        }
        if(type == "video"){
            val microSecond = 0L
            val options =  RequestOptions()
                    .frame(microSecond)
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .fitCenter()
                    .override(w, h)
            Glide.with(context).load(url)
                    .apply(options)
                    .into(this)
        }

    }

    private fun updateImageCache(url:String,type:String){
        if(type == "image"){
            val options =  RequestOptions()
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
            Glide.with(context).load(url).apply(options).into(this)
        }
        if(type == "video"){
            val microSecond = 0L
            val options =  RequestOptions()
                    .frame(microSecond)
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
            Glide.with(context).load(url)
                    .apply(options)
                    .into(this)
        }
    }

    private fun updateImageNoCache(url:String,type:String,w:Int,h:Int){
        if(type == "image"){
            val options =  RequestOptions().fitCenter().override(w, h)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .skipMemoryCache(true)
            Glide.with(context).load(url).apply(options).into(this)
        }
        if(type == "video"){
            val microSecond = 0L
            val options =  RequestOptions()
                    .frame(microSecond)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .fitCenter()
                    .override(w, h)
                    .skipMemoryCache(true)
            Glide.with(context).load(url)
                    .apply(options)
                    .into(this)
        }
    }
    private fun updateImageNoCache(url:String,type:String){
        if(type == "image"){
            val options =  RequestOptions()
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .skipMemoryCache(true)
            Glide.with(context).load(url).apply(options).into(this)
        }
        if(type == "video"){
            val microSecond = 0L
            val options =  RequestOptions()
                    .frame(microSecond)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .skipMemoryCache(true)
            Glide.with(context).load(url)
                    .apply(options)
                    .into(this)
        }
    }
}