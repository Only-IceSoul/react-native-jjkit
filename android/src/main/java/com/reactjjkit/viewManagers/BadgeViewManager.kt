package com.reactjjkit.viewManagers

import android.content.Context
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.*
import com.reactjjkit.shadowNodes.BadgeShadowNode
import com.reactjjkit.views.Badge


class BadgeViewManager : SimpleViewManager<Badge>() {

    override fun getName(): String {
        return "Badge"
    }

    override fun createShadowNodeInstance(context: ReactApplicationContext): BadgeShadowNode {
        return BadgeShadowNode(context)
    }

    override fun createViewInstance(reactContext: ThemedReactContext): Badge {
        return  Badge(reactContext as Context)
    }


    //region Badge set and get

    @ReactProp(name = "text")
    fun text(view: Badge,text: String?)  {
        view.setText(text)
    }


    @ReactProp(name = "font")
    fun font(view: Badge,font: String?) {
        view.setTypeFace(font)
    }


    @ReactProp(name = "textSize")
    fun textSize(view: Badge, textSize: Float) {
        view.setTextSize(textSize)
    }


    @ReactProp(name = "textColor")
    fun textColor(view: Badge,hex: String?) {
        view.setTextColor(hex)
    }

    @ReactProp(name = "strokeColor")
    fun strokeColor(view: Badge,hex:String?) {
        view.setBadgeStrokeColor(hex)

    }
    @ReactProp(name = "strokeWidth")
    fun strokeWidth(view: Badge,width:Float)  {
        view.setBadgeStrokeWidth(width)
    }



    @ReactProp(name = "isTextHidden")
    fun isTextHidden(view: Badge,boolean: Boolean)  {
        view.setIsTextHidden(boolean)
    }
    @ReactProp(name = "textOffsetX")
    fun textOffsetX(view: Badge,value: Float)  {
        view.setTextOffsetX(value)
    }
    @ReactProp(name = "textOffsetY")
    fun textOffsetY(view: Badge,value: Float)  {
        view.setTextOffsetY(value)
    }

    @ReactProp(name = "insetX")
    fun insetX(view: Badge,value: Float)  {
        view.setInsetX(value)
    }
    @ReactProp(name = "insetY")
    fun insetY(view: Badge,value: Float)  {
        view.setInsetY(value)
    }



    //endregion



}