//
//  GuisoRequestBuilder.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit


class GuisoRequestBuilder {
    
    private var mUrl:String = "error"
    private var mScaleType = Guiso.ScaleType.fill
    private var mOverrideW:CGFloat = -1
    private var mOverrideH:CGFloat = -1
    private var mFrameSecond : Double = 0
    private var mSkipMemoryCache = false
    private var mMediaType = Guiso.MediaType.image
    private var mIsOverride = false
    private var mLanczos5 = false
    private var mDiskCacheStrategy : Guiso.DiskCacheStrategy = .automatic
    init(_ url:String) {
      mUrl = url
    }
    
    func asGif() -> GuisoRequestBuilder {
        mMediaType = .gif
        return self
    }
    func fitCenter() -> GuisoRequestBuilder {
        mScaleType = .fitCenter
        return self
    }
    
    func cropCenter() -> GuisoRequestBuilder {
        mScaleType = .centerCrop
          return self
    }
    
    func override(_ width:CGFloat,_ height:CGFloat) -> GuisoRequestBuilder{
        mOverrideW = width
        mOverrideH = height
        mIsOverride = true
        return self
    }
    
    func lanczos5Resampling() -> GuisoRequestBuilder{
        mLanczos5 = true
        return self
    }
    
    func frame(_ second:Double) -> GuisoRequestBuilder{
        mFrameSecond = second
        return self
    }
    
    func skipMemoryCache()->GuisoRequestBuilder{
        mSkipMemoryCache = true
        return self
    }
    
    @discardableResult
    func into(_ target: ViewTarget) -> ViewTarget {
        Guiso.get().putLoad(self,target)
        return target
    }
    
    func disCacheStrategy(_ strategy: Guiso.DiskCacheStrategy) -> GuisoRequestBuilder{
//        mDiskCacheStrategy = strategy
        return self
    }
    
    func getUrl() -> String {
        return mUrl
    }

    func getScaleType() -> Guiso.ScaleType {
        return mScaleType
    }
    
    func getWidth() -> CGFloat{
        return mOverrideW
    }
    func getHeight() -> CGFloat{
        return mOverrideH
    }
    func getMediaType() -> Guiso.MediaType {
        return mMediaType
    }
    func getSkipMemoryCache() -> Bool {
        return mSkipMemoryCache
    }
    func getFrameSecond() -> Double {
        return mFrameSecond
    }
    func getIsOverride() -> Bool {
        return mIsOverride
    }
    func getDiskCacheStrategy() -> Guiso.DiskCacheStrategy {
        return mDiskCacheStrategy
    }
    
    func getLanczos()->Bool {
        return mLanczos5
    }
    
    
}
