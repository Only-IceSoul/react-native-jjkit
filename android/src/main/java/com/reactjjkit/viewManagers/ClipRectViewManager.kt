package com.reactjjkit.viewManagers

import android.content.Context
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.*
import com.reactjjkit.views.ClipRectView


class ClipRectViewManager : ViewGroupManager<ClipRectView>() {


    override fun getName(): String {
        return "ClipRectView"
    }

    override fun createViewInstance(reactContext: ThemedReactContext): ClipRectView {
        return  ClipRectView(reactContext as Context)
    }


    //region  set and get

    @ReactProp(name = "gravity")
    fun setGravity(view:ClipRectView, gravity:String?)  {
        view.setGravity(gravity)
    }
    @ReactProp(name = "progress")
    fun setProgress(view:ClipRectView,progress: Float)  {
        view.setProgress(progress)
    }
    @ReactProp(name = "inset")
    fun setInset(view:ClipRectView, inset: Float)  {
        view.setInset(inset)
    }

    //endregion



}