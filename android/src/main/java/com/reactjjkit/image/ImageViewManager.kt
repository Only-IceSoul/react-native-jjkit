package com.reactjjkit.image

import android.content.Context
import android.widget.ImageView
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

class ImageViewManager : SimpleViewManager<JJImageView>() {

    override fun getName(): String {
        return "Image"
    }

    override fun createViewInstance(reactContext: ThemedReactContext): JJImageView {
        return  JJImageView(reactContext as Context)
    }

    @ReactProp(name = "data")
    fun data(view: JJImageView, data: ReadableMap?)  {
        view.setData(data)
    }

    @ReactProp(name = "scaleType")
    fun scaleType(view: JJImageView, scaleType: Int) {
        when(scaleType){
            1 -> view.scaleType = ImageView.ScaleType.FIT_CENTER
            else -> view.scaleType = ImageView.ScaleType.CENTER_CROP
        }
    }
}