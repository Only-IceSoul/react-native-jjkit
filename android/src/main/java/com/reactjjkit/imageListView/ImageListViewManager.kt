package com.reactjjkit.imageListView

import com.facebook.react.bridge.*
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp


class ImageListViewManager() : SimpleViewManager<ImageListView>() {

    companion object{
        const val EVENT_ON_END_REACHED = "onEndReached"
        const val EVENT_ON_ITEM_CLICKED = "onItemClicked"


    }


    override fun getName(): String {
        return "ImageListView"
    }

    override fun createViewInstance(reactContext: ThemedReactContext): ImageListView {
        return  ImageListView(reactContext)
    }






    //region Badge set and get

    @ReactProp(name = "source")
    fun source(view: ImageListView, data: ReadableMap?){
        view.source(data)
    }


    //endregion


    override fun getExportedCustomBubblingEventTypeConstants(): MutableMap<String, Any> {
        return MapBuilder.builder<String,Any>()
                .put(EVENT_ON_END_REACHED, MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled",EVENT_ON_END_REACHED)))
                .put(EVENT_ON_ITEM_CLICKED, MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled",EVENT_ON_ITEM_CLICKED)))
                .build()
    }



}