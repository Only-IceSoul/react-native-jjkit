package com.reactjjkit.viewManagers

import android.content.Context
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.*
import com.reactjjkit.views.CircleProgressView


class CircleProgressViewManager : ViewGroupManager<CircleProgressView>() {


    override fun getName(): String {
        return "CircleProgressView"
    }

    override fun createViewInstance(reactContext: ThemedReactContext): CircleProgressView {
        return  CircleProgressView(reactContext as Context)
    }


    //region set and get


    @ReactProp(name = "strokeWidth",defaultFloat = 4f)
    fun setStrokeWidth(view:CircleProgressView, size:Float)  {
        view.setStrokeWidth(size)
    }
    @ReactProp(name = "colors")
    fun setColors(view:CircleProgressView,colors: ReadableArray?)  {
        view.setColors(colors)
    }
    @ReactProp(name = "positions")
    fun setPositions(view:CircleProgressView,positions: ReadableArray?)  {
        view.setPositions(positions)
    }
    @ReactProp(name = "backColors")
    fun setBackColors(view:CircleProgressView,colors: ReadableArray?) {
        view.setBackColors(colors)
    }
    @ReactProp(name = "backPositions")
    fun setBackPositions(view:CircleProgressView,positions: ReadableArray?)  {
        view.setBackPositions(positions)
    }
    @ReactProp(name = "progress")
    fun setProgress(view:CircleProgressView,num: Float)  {
        view.setProgress(num)
    }
    @ReactProp(name = "cap")
    fun setCap(view:CircleProgressView,cap: String?){
        view.setCap(cap)
    }

    //endregion



}