package com.reactjjkit.imageListView

import android.graphics.Rect
import android.view.View
import com.facebook.react.bridge.*
import com.facebook.react.uimanager.UIManagerModule
import java.lang.Exception

class ImageListViewModule (context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {

    private val mContext = context

    @ReactMethod
    fun getSelectedItems(tag: Int, promise: Promise){
        try{
            val uiManager: UIManagerModule = mContext.getNativeModule(UIManagerModule::class.java)
            val view: View = uiManager.resolveView(tag)
            if (view is ImageListView) {
                val arr = Arguments.createArray()
                view.getSelectedItems().forEach {
                    arr.pushMap(Arguments.makeNativeMap(it))
                }
                promise.resolve(arr)
            } else {
                throw Error("Expecting a ImageListView, got: $view")
            }
        }catch (e: Exception){
            promise.reject(e)
        }

    }

    @ReactMethod
    fun addItems(tag: Int,items:ReadableArray?){
        try{
            val uiManager: UIManagerModule = mContext.getNativeModule(UIManagerModule::class.java)
            val view: View = uiManager.resolveView(tag)
            if (view is ImageListView) {
               view.addItems(items)
            } else {
                throw Error("Expecting a ImageListView, got: $view")
            }
        }catch (e: Exception){

        }

    }

    override fun getName(): String {
       return "ImageListView"
    }
}