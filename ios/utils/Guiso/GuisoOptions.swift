//
//  GuisoOptions.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit


public class GuisoOptions {
  
      private var mScaleType = Guiso.ScaleType.none
      private var mOverrideW:CGFloat = -1
      private var mOverrideH:CGFloat = -1
      private var mFrameSecond : Double = 0
      private var mSkipMemoryCache = false
      private var mAsAnimatedImage = false
    private var mAnimatedType = Guiso.AnimatedType.gif
      private var mIsOverride = false
      private var mLanczos5 = false
      private var mExactFrame = false
      private var mSignature = ""
      private var mDiskCacheStrategy : Guiso.DiskCacheStrategy = .automatic
      private var mHeader: GuisoHeader?
    private var mErrorHolder: GuisoErrorHolder?
    private var mFallbackHolder: GuisoFallbackHolder?
    private var mPlaceHolder : GuisoPlaceHolder?
     private var mTransform : TransformProtocol?
     private var mSignatureTransformer = ""
       private var mPriority = Guiso.Priority.low
    private var mThumb : GuisoRequestBuilder?
    @discardableResult
    public func header(_ header:GuisoHeader) -> GuisoOptions{
        mHeader = header
        return self
    }
    @discardableResult
      public func signature(string:String) -> GuisoOptions{
         mSignature = string
          return self
      }
    
      @discardableResult
    public func asAnimatedImage(_ type:Guiso.AnimatedType) -> GuisoOptions {
          mAsAnimatedImage = true
         mAnimatedType = type
          return self
      }
    @discardableResult
      public func fitCenter() -> GuisoOptions {
          mScaleType = .fitCenter
          return self
      }
      @discardableResult
      public func centerCrop() -> GuisoOptions {
          mScaleType = .centerCrop
            return self
      }
    @discardableResult
    public func transform(signature:String,_ transform:TransformProtocol) -> GuisoOptions {
        if signature.isEmpty { fatalError("siganture transform is empty") }
        mTransform = transform
        mSignatureTransformer = signature
       return self
    }
    
    @discardableResult
       public func placeHolder(_ place:UIImage) -> GuisoOptions {
         mPlaceHolder = GuisoPlaceHolder(place)
          return self
       }
       @discardableResult
          public func placeHolder(_ place:UIColor) -> GuisoOptions {
            mPlaceHolder = GuisoPlaceHolder(place)
             return self
          }
       @discardableResult
          public func placeHolder(_ place:String) -> GuisoOptions {
            mPlaceHolder = GuisoPlaceHolder(place)
             return self
          }
       
     @discardableResult
    public func error(_ error:UIImage) -> GuisoOptions {
      mErrorHolder = GuisoErrorHolder(error)
       return self
    }
    @discardableResult
       public func error(_ error:UIColor) -> GuisoOptions {
         mErrorHolder = GuisoErrorHolder(error)
          return self
       }
    @discardableResult
       public func error(_ error:String) -> GuisoOptions {
         mErrorHolder = GuisoErrorHolder(error)
          return self
       }
    
    @discardableResult
       public func error(_ errorRequest:GuisoRequestBuilder) -> GuisoOptions {
         mErrorHolder = GuisoErrorHolder(errorRequest)
          return self
       }
    
    @discardableResult
      public func fallback(_ fallback:UIImage) -> GuisoOptions {
        mFallbackHolder = GuisoFallbackHolder(fallback)
         return self
      }
      @discardableResult
         public func fallback(_ fallback:UIColor) -> GuisoOptions {
           mFallbackHolder = GuisoFallbackHolder(fallback)
            return self
         }
      @discardableResult
         public func fallback(_ fallback:String) -> GuisoOptions {
           mFallbackHolder = GuisoFallbackHolder(fallback)
            return self
         }
      @discardableResult
      public func override(_ width:Int,_ height:Int) -> GuisoOptions{
        mOverrideW = width > 10 ? CGFloat(width) : -1
         mOverrideH = height > 10 ? CGFloat(height) : -1
         mIsOverride = mOverrideW != -1 && mOverrideH != -1
          return self
      }
      @discardableResult
      public func lanczos5Resampling() -> GuisoOptions{
          mLanczos5 = true
          return self
      }
      @discardableResult
      public func frame(_ second:Int,exact: Bool = false) -> GuisoOptions{
          mFrameSecond = Double(second)
          mExactFrame = exact
          return self
      }
      @discardableResult
    public func skipMemoryCache(_ bool:Bool)->GuisoOptions{
          mSkipMemoryCache = bool
          return self
      }
      @discardableResult
      public func diskCacheStrategy(_ strategy: Guiso.DiskCacheStrategy) -> GuisoOptions{
          mDiskCacheStrategy = strategy
          return self
      }
    @discardableResult
    public func priority(_ priority: Guiso.Priority) -> GuisoOptions{
            mPriority = priority
            return self
    }
    @discardableResult
    public func thumbnail(_ thumb: GuisoRequestBuilder) -> GuisoOptions{
            mThumb = thumb
            return self
    }
    
    func getThumbnail() -> GuisoRequestBuilder?{
        return mThumb
    }

      public func getSignature() -> String {
          return mSignature
      }

      public func getHeader() -> GuisoHeader? {
          return mHeader
      }
      
      public func getScaleType() -> Guiso.ScaleType {
          return mScaleType
      }
     func getErrorHolder() -> GuisoErrorHolder? {
        return mErrorHolder
    }
      func getFallbackHolder() -> GuisoFallbackHolder? {
          return mFallbackHolder
      }
    func getPlaceHolder() -> GuisoPlaceHolder? {
        return mPlaceHolder
    }
      public func getWidth() -> CGFloat{
          return mOverrideW
      }
      public func getHeight() -> CGFloat{
          return mOverrideH
      }
      public func getAsAnimatedImage() -> Bool {
          return mAsAnimatedImage
      }
    public func getAnimatedType() -> Guiso.AnimatedType {
        return mAnimatedType
    }
    public func getTransformerSignature() -> String {
        return mSignatureTransformer
    }
      public func getSkipMemoryCache() -> Bool {
          return mSkipMemoryCache
      }
      public func getFrameSecond() -> Double {
          return mFrameSecond
      }
      public func getIsOverride() -> Bool {
          return mIsOverride
      }
      public func getDiskCacheStrategy() -> Guiso.DiskCacheStrategy {
          return mDiskCacheStrategy
      }
    public func getTransformer() -> TransformProtocol?{
        return mTransform
    }
      public func getLanczos()->Bool {
          return mLanczos5
      }
      public func getExactFrame() -> Bool {
          return mExactFrame
      }
    public func getPriority() -> Guiso.Priority {
        return mPriority
    }
}
