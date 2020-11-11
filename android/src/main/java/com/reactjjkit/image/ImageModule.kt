package com.reactjjkit.image

import android.graphics.Bitmap
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import androidx.core.graphics.drawable.toBitmap
import com.bumptech.glide.Glide
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.uimanager.UIManagerModule
import com.reactjjkit.photoKit.PhotoKitModule
import java.io.ByteArrayOutputStream

class ImageModule(context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {

    private val reactContext = context

    @ReactMethod
    fun requestImageByTag(tag: Int,format:String,quality:Float, promise: Promise){
        try{
            val view = getImageView(tag)
            if (view != null) {
                val f = if(format == PhotoKitModule.COMPRESS_FORMAT_PNG) Bitmap.CompressFormat.PNG else Bitmap.CompressFormat.JPEG
                val q = (quality * 100).toInt()
                val bytes = ByteArrayOutputStream()
                if(view.drawable.toBitmap().compress(f,q,bytes)){
                    promise.resolve(android.util.Base64.encodeToString(bytes.toByteArray(), android.util.Base64.DEFAULT))
                }else{
                    throw Error("failed to compress format $format")
                }

            } else {
                throw Error("Expecting a JJImageView, got: $view")
            }
        }catch (e: Exception){
            promise.reject(e)
        }
    }
    @ReactMethod
    fun clear(tag:Int){
        getImageView(tag)?.let {
            Handler(Looper.getMainLooper()).post {
                Glide.with(reactContext).clear(it)
            }
        }
    }

    private fun getImageView(tag:Int) : JJImageView? {
        val uiManager: UIManagerModule = reactContext.getNativeModule(UIManagerModule::class.java)
        val view: View = uiManager.resolveView(tag)
        if (view is JJImageView) {
            return view
        }
        return null
    }

    override fun getName(): String {
        return "Image"
    }
}