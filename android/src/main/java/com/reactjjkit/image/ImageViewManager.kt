package com.reactjjkit.image

import android.content.Context
import android.widget.ImageView
import com.bumptech.glide.Glide
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

class ImageViewManager : SimpleViewManager<JJImageView>() {

    companion object{
        const val EVENT_ON_LOAD_START = "onLoadStart"
        const val EVENT_ON_LOAD_END = "onLoadEnd"
        const val EVENT_ON_LOAD_ERROR = "onLoadError"
        const val EVENT_ON_LOAD_SUCCESS = "onLoadSuccess"
    }

    override fun getName(): String {
        return "Image"
    }

    override fun createViewInstance(reactContext: ThemedReactContext): JJImageView {
        return  JJImageView(reactContext as Context)
    }

    @ReactProp(name = "source")
    fun source(view: JJImageView, data: ReadableMap?)  {
        view.setSrc(data)
    }

    @ReactProp(name = "scaleType")
    fun scaleType(view: JJImageView, scaleType: String) {
        when(scaleType){
            JJImageView.SCALE_TYPE_COVER -> view.scaleType = ImageView.ScaleType.CENTER_CROP
            else -> view.scaleType = ImageView.ScaleType.FIT_CENTER
        }
    }

    override fun onDropViewInstance(view: JJImageView) {
        Glide.with(view).clear(view)
        super.onDropViewInstance(view)
    }


    override fun getExportedCustomBubblingEventTypeConstants(): MutableMap<String, Any> {
        return MapBuilder.builder<String,Any>()
                .put(EVENT_ON_LOAD_START, MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", EVENT_ON_LOAD_START)))
                .put(EVENT_ON_LOAD_END, MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", EVENT_ON_LOAD_END)))
                .put(EVENT_ON_LOAD_ERROR, MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", EVENT_ON_LOAD_ERROR)))
                .put(EVENT_ON_LOAD_SUCCESS, MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", EVENT_ON_LOAD_SUCCESS)))
                .build()
    }
}