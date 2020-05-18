//
//  GuisoRequestBuilder.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit


class GuisoRequestBuilder {
    
    
   private var mUrl:String = ""
   private var mData : Data?
   private var mScaleType = Guiso.ScaleType.none
   private var mOverrideW:CGFloat = -1
   private var mOverrideH:CGFloat = -1
   private var mFrameSecond : Double = 0
   private var mSkipMemoryCache = false
   private var mMediaType = Guiso.MediaType.image
   private var mIsOverride = false
   private var mLanczos5 = false
   private var mExactFrame = false
   private var mSignature = ""
   private var mDiskCacheStrategy : Guiso.DiskCacheStrategy = .automatic
   
   public init(_ url:String) {
     mUrl = url
     mSignature = url
   }
   public init(_ data:Data) {
     mData = data
   }
   
   public func signature(string:String) -> GuisoRequestBuilder{
      mSignature = string
       return self
   }
   
   public func asGif() -> GuisoRequestBuilder {
       mMediaType = .gif
       return self
   }
   public func fitCenter() -> GuisoRequestBuilder {
       mScaleType = .fitCenter
       return self
   }
   
   public func centerCrop() -> GuisoRequestBuilder {
       mScaleType = .centerCrop
         return self
   }
   
   public func override(_ width:CGFloat,_ height:CGFloat) -> GuisoRequestBuilder{
       mOverrideW = width
       mOverrideH = height
       mIsOverride = true
       return self
   }
   
   public func lanczos5Resampling() -> GuisoRequestBuilder{
       mLanczos5 = true
       return self
   }
   
   public func frame(_ second:Double,exact: Bool = false) -> GuisoRequestBuilder{
       mFrameSecond = second
       mExactFrame = exact
       return self
   }
   
   public func skipMemoryCache()->GuisoRequestBuilder{
       mSkipMemoryCache = true
       return self
   }
   
   @discardableResult
   public func into(_ target: ViewTarget) -> ViewTarget {
       Guiso.get().putLoad(self,target)
       return target
   }
   
   public func diskCacheStrategy(_ strategy: Guiso.DiskCacheStrategy) -> GuisoRequestBuilder{
       mDiskCacheStrategy = strategy == .none ? strategy : .automatic
       return self
   }
   
   func getUrl() -> String {
       return mUrl
   }
   
   func getSignature() -> String {
       return mSignature
   }
   
   func getData() -> Data? {
         return mData
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
   func getExactFrame() -> Bool {
       return mExactFrame
   }
       
       
    
}
