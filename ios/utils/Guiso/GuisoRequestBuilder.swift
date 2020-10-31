//
//  GuisoRequestBuilder.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit


public class GuisoRequestBuilder {
    
    private var mOptions  = GuisoOptions()
    private var mLoader: LoaderProtocol!
    private var mModel: Any?
    private var mPrimarySignature = ""
 
    private var mAnimatedImageDecoder : AnimatedImageDecoderProtocol = GuisoGifDecoder()
    
    private var mThumb : GuisoRequestBuilder?
     init(model:Any?) {
           mModel = model
           mLoader = GuisoLoaderString()
        if let s = model as? String {
            mPrimarySignature =  s
        }else if let ss = model as? URL{
            mModel = ss.absoluteString
            mPrimarySignature = ss.absoluteString
        }else{
            mLoader = GuisoLoaderData()
        }
       
    }
    
    init(model:Any?, loader:LoaderProtocol) {
          mModel = model
         mLoader = loader
    }

    public func AnimatedImageDecoder(_ decoder:AnimatedImageDecoderProtocol) -> GuisoRequestBuilder{
           mAnimatedImageDecoder = decoder
           return self
    }
    
    
    public func header(_ header:GuisoHeader) -> GuisoRequestBuilder{
        mOptions.header(header)
        return self
    }
    
    public func signature(string:String) -> GuisoRequestBuilder{
        mOptions.signature(string: string)
        return self
    }
    
    public func placeHolder(_ name:String) -> GuisoRequestBuilder {
        mOptions.placeHolder(name)
        return self
    }
    
    public func placeHolder(_ image:UIImage) -> GuisoRequestBuilder {
       mOptions.placeHolder(image)
       return self
    }
    public func placeHolder(_ color:UIColor) -> GuisoRequestBuilder {
         mOptions.placeHolder(color)
       return self
    }
    public func error(_ name:String) -> GuisoRequestBuilder {
        mOptions.error(name)
       return self
    }
    public func error(_ request:GuisoRequestBuilder) -> GuisoRequestBuilder {
        mOptions.error(request)
       return self
    }
    public func error(_ image:UIImage) -> GuisoRequestBuilder {
      mOptions.error(image)
      return self
    }
    public func error(_ color:UIColor) -> GuisoRequestBuilder {
       mOptions.error(color)
      return self
    }
    public func fallback(_ name:String) -> GuisoRequestBuilder {
        mOptions.fallback(name)
        return self
    }

    public func fallback(_ image:UIImage) -> GuisoRequestBuilder {
        mOptions.fallback(image)
        return self
    }
    public func fallback(_ color:UIColor) -> GuisoRequestBuilder {
        mOptions.fallback(color)
        return self
    }
    public func asAnimatedImage(_ type:Guiso.AnimatedType) -> GuisoRequestBuilder {
        switch type {
        case .gif:
            mAnimatedImageDecoder = GuisoGifDecoder()
            break
        case .webp:
            mAnimatedImageDecoder = GuisoWebPDecoder()
            break
            
        }
        mOptions.asAnimatedImage(type)
        return self
    }
    public func fitCenter() -> GuisoRequestBuilder {
        mOptions.fitCenter()
        return self
    }
    
    public func transform(signature: String,_ trans:TransformProtocol) -> GuisoRequestBuilder {
        mOptions.transform(signature:signature,trans)
        return self
    }
    
    public func centerCrop() -> GuisoRequestBuilder {
        mOptions.centerCrop()
          return self
    }
    
    public func priority(_ priority:Guiso.Priority) -> GuisoRequestBuilder {
        mOptions.priority(priority)
        return self
    }
    
    public func override(_ width:Int,_ height:Int) -> GuisoRequestBuilder{
        mOptions.override(width, height)
        return self
    }
    
    public func lanczos5Resampling() -> GuisoRequestBuilder{
        mOptions.lanczos5Resampling()
        return self
    }
    
    public func frame(_ second:Int,exact: Bool = false) -> GuisoRequestBuilder{
        mOptions.frame(second,exact: exact)
        return self
    }
    
    public func skipMemoryCache(_ bool:Bool)->GuisoRequestBuilder{
        mOptions.skipMemoryCache(bool)
        return self
    }
    public func thumbnail(_ t: GuisoRequestBuilder) -> GuisoRequestBuilder{
        mThumb = t
        return self
    }
    @discardableResult
    public func into(_ target: ViewTarget) -> ViewTarget? {
    
        return GuisoRequestManager.into(target, builder: self)
    }
    
    public func getThumb() -> GuisoRequestBuilder?{
        return mThumb
    }
    
  
    public func preload() -> GuisoPreload {
   
        return GuisoPreload(model: mModel,mPrimarySignature, options: mOptions, loader: mLoader, animImgDecoder: mAnimatedImageDecoder)
    }
    
    public func diskCacheStrategy(_ strategy: Guiso.DiskCacheStrategy) -> GuisoRequestBuilder{
        mOptions.diskCacheStrategy(strategy)
        return self
    }
    
    func getLoader() -> LoaderProtocol {
        return mLoader
    }
    func getAnimatedImageDecoder() -> AnimatedImageDecoderProtocol {
        return mAnimatedImageDecoder
    }
    func getModel() -> Any? {
        return mModel
    }
    
    func getPrimarySignature()->String{
        return mPrimarySignature
    }
    
   
    func apply(_ options:GuisoOptions) -> GuisoRequestBuilder{
        mOptions = options
        switch mOptions.getAnimatedType() {
        case .gif:
            mAnimatedImageDecoder = GuisoGifDecoder()
            break
        case .webp:
            mAnimatedImageDecoder = GuisoWebPDecoder()
            break
            
        }
        return self
    }
 
    func getOptions() -> GuisoOptions {
        return mOptions
    }
    

    
    
  
}
