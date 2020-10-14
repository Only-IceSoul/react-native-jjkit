package com.reactjjkit


import android.view.View
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ReactShadowNode
import com.facebook.react.uimanager.ViewManager
import com.reactjjkit.cropper.CropperModule
import com.reactjjkit.image.ImageViewManager
import com.reactjjkit.imageListView.ImageListViewManager
import com.reactjjkit.imageListView.ImageListViewModule
import com.reactjjkit.viewManagers.CircleProgressViewManager
import com.reactjjkit.viewManagers.ClipRectViewManager
import com.reactjjkit.modules.ToastModule
import com.reactjjkit.photoKit.PhotoKitModule
import com.reactjjkit.viewManagers.BadgeViewManager

@Suppress("UNCHECKED_CAST")
class JJKitPackage : ReactPackage {

    override fun createNativeModules(reactContext: ReactApplicationContext): MutableList<NativeModule> {
        return mutableListOf(
             ToastModule(reactContext),
             PhotoKitModule(reactContext),
                CropperModule(reactContext),
                ImageListViewModule(reactContext)
        )
    }

    override fun createViewManagers(reactContext: ReactApplicationContext): MutableList<ViewManager<View, ReactShadowNode<*>>> {
        return mutableListOf(
                CircleProgressViewManager(),
                 ClipRectViewManager() ,
                BadgeViewManager(),
                ImageViewManager(),
                ImageListViewManager()
        ) as MutableList<ViewManager<View, ReactShadowNode<*>>>
    }
}