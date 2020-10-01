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
 
    private var mGifDecoder : GifDecoderProtocol = GuisoGifDecoder()
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

    public func gifDecoder(_ decoder:GifDecoderProtocol) -> GuisoRequestBuilder{
           mGifDecoder = decoder
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
    public func asGif() -> GuisoRequestBuilder {
        mOptions.asGif()
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
        mOptions.thumbnail(t)
        return self
    }
    @discardableResult
    public func into(_ target: ViewTarget) -> ViewTarget? {
    
        return GuisoRequestManager.into(target, builder: self)
    }
    
    @discardableResult
    public func preload() -> Bool {
        return GuisoRequestManager.preload(mModel,mPrimarySignature, loader: mLoader, gifd: mGifDecoder, options: mOptions)
    }
    
    public func diskCacheStrategy(_ strategy: Guiso.DiskCacheStrategy) -> GuisoRequestBuilder{
        mOptions.diskCacheStrategy(strategy)
        return self
    }
    
    func getLoader() -> LoaderProtocol {
        return mLoader
    }
    func getGifDecoder() -> GifDecoderProtocol {
        return mGifDecoder
    }
    func getModel() -> Any? {
        return mModel
    }
    
    func getPrimarySignature()->String{
        return mPrimarySignature
    }
    
   
    func apply(_ options:GuisoOptions) -> GuisoRequestBuilder{
        mOptions = options
        return self
    }
 
    func getOptions() -> GuisoOptions {
        return mOptions
    }
    

    
    
  
}
