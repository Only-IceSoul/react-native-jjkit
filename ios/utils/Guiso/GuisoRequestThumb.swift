//
//  GuisoRequestThumb.swift
//  Guiso
//
//  Created by Juan J LF on 5/22/20.
//

import UIKit
import Photos

class GuisoRequestThumb : Runnable {
    

    private var mModel: Any!
    private var mLoader : LoaderProtocol!
    private var mTarget : ViewTarget?
    private var mKey : String = ""
    private var mOptions : GuisoOptions!
    private var mTransformer: GuisoTransform!
    private var mScale : Guiso.ScaleType!
    private var mGifDecoder : GifDecoderProtocol!
    private var mSaver:GuisoSaver!
    private var mPrimarySignature = ""
    init(model:Any,_ primarySignature:String,options:GuisoOptions,_ target: ViewTarget?, loader: LoaderProtocol,gifDecoder : GifDecoderProtocol) {
        mOptions = options
        mModel = model
        mPrimarySignature = primarySignature
        mGifDecoder = gifDecoder
        mTarget = target
        mLoader = loader
        mScale = mOptions.getScaleType()  == .none ? getScaleTypeFrom(mTarget?.getContentMode() ?? .scaleAspectFit): mOptions.getScaleType()
        let key = makeKey()
        mKey = key.toString()
        mTransformer = GuisoTransform(scale: mScale, l: mOptions.getLanczos())
        mSaver = GuisoSaver()
       
    }
    private var mTask: DispatchWorkItem?
    public func setTask(_ t:DispatchWorkItem){
        mTask = t
    }
    
    
    func run(){

        if !updateImageFromCache()  {
            if !updateFromSourceCache(){
                
                mLoader.loadData(model: mModel!, width: mOptions.getWidth(), height: mOptions.getHeight(), options: mOptions) { (result, type,error,dataSource) in
                    if Thread.isMainThread {
                        Guiso.get().getExecutor().doWork {
                            if self.mOptions.getAsGif() {
                                self.handleGif(result, type: type)
                            }else{
                                self.handleImage(result,type:type)
                            }
                        }
                    }else{
                        if self.mOptions.getAsGif() {
                           self.handleGif(result, type: type)
                        }else{
                           self.handleImage(result,type:type)
                        }
                    }
                  
                }

            }
        } //cache

        
    }
    func handleImage(_ result:Any?,type:Guiso.LoadType){
        if type == .data {
           
            guard let data = result as? Data,
                  let img = UIImage(data: data)
                else {
                    self.onLoadFailed()
                    return
            }
   
            transformDisplayCacheImage(img)
            
        }
    
        if type == .uiimg{
            guard let img = result as? UIImage
               else {
                   self.onLoadFailed()
                   return
            }
            transformDisplayCacheImage(img)
        }
    }
    func handleGif(_ result:Any?,type:Guiso.LoadType){
          if type == .data {
            guard let data = result as? Data,
            let gif = self.mGifDecoder.decode(data:data) else {
                self.onLoadFailed()
                return
            }
             transformDisplayCacheGif(gif)
          }
          if type == .uiimg {
              guard let img = result as? UIImage
                  else{
                      self.onLoadFailed()
                      return
              }
              
              self.displayInTarget(img)
              if !self.mOptions.getSignature().isEmpty {
                  self.mSaver.saveToMemoryCache(key: self.mKey,image:img)
                  self.mSaver.saveToDiskCache(key: self.mKey, image: img)
              }
          }
      }
    
    func transformDisplayCacheImage(_ img: UIImage){
        var final: UIImage? = img
        if self.mOptions.getIsOverride() {
           final = self.mTransformer.transformImage(img: img, outWidth: mOptions.getWidth(), outHeight: mOptions.getHeight())
        }
        if self.mOptions.getTransformer() != nil {
           final  = self.mOptions.getTransformer()?.transformImage(img: img, outWidth: mOptions.getWidth(), outHeight: mOptions.getHeight())
        }
        if final != nil {
           self.displayInTarget(final!)
           if !self.mOptions.getSignature().isEmpty {
              
               self.mSaver.saveToMemoryCache(key: self.mKey, image:final!)
               self.mSaver.saveToDiskCache(key: self.mKey, image: final!)
           }
        }else{
           self.onLoadFailed()
        }
    }
  
    
    func transformDisplayCacheGif(_ gifObj:Gif){
          let gif = gifObj
          if self.mOptions.getIsOverride() {
              var images = [CGImage]()
              gif.frames.forEach { (cg) in
               let i = self.mTransformer.transformGif(cg: cg, outWidth: self.mOptions.getWidth(), outHeight: self.mOptions.getHeight())
                  if i != nil { images.append(i!) }
              }
              gif.frames = images
          }

          if self.mOptions.getTransformer() != nil {
              var images = [CGImage]()
              gif.frames.forEach { (cg) in
                  let i = self.mOptions.getTransformer()!.transformGif(cg: cg, outWidth: self.mOptions.getWidth(), outHeight: self.mOptions.getHeight())
                  if i != nil { images.append(i!) }
              }
              gif.frames = images
          }

          let drawable = TransformationUtils.cleanGif(gif)
          self.displayInTarget(drawable)
          if !self.mOptions.getSignature().isEmpty {
              self.mSaver.saveToMemoryCache(key: self.mKey, gif: drawable)
              self.mSaver.saveToDiskCache(key: self.mKey, gif: drawable)
          }
    }
    

  
    func makeKey() -> Key {
        let key = mOptions.getIsOverride() ? Key(signature:mPrimarySignature ,extra:mOptions.getSignature(), width: mOptions.getWidth(), height: mOptions.getHeight(), scaleType: mScale, frame: mOptions.getFrameSecond()   ,exactFrame:mOptions.getExactFrame(), isGif:mOptions.getAsGif(), transform: mOptions.getTransformerSignature()) :
            Key(signature: mPrimarySignature,extra:mOptions.getSignature(), width: -1, height: -1, scaleType: .none,frame: mOptions.getFrameSecond()  ,exactFrame:mOptions.getExactFrame(), isGif: mOptions.getAsGif(),
        transform: mOptions.getTransformerSignature())
        return key
    }
    private func getScaleTypeFrom(_ scale:UIView.ContentMode)-> Guiso.ScaleType{
        return scale == UIView.ContentMode.scaleAspectFill ? .centerCrop : .fitCenter
    }
    
    func keySource() -> Key {
        return  Key(signature: mPrimarySignature,extra:mOptions.getSignature(), width: -1, height: -1, scaleType: .none,frame: mOptions.getFrameSecond()  ,exactFrame:mOptions.getExactFrame(), isGif: mOptions.getAsGif(),
          transform: "")
    }
    func updateFromSourceCache() -> Bool{
        let key = keySource().toString()
        let diskCache = Guiso.get().getDiskCache()
        let diskCacheGif = Guiso.get().getDiskCacheObject()
        if mOptions.getAsGif(){
            if let obj = diskCacheGif.get(key) {
                if let gif = obj as? Gif{
                    transformDisplayCacheGif(gif)
                    return true
                }
            }
        }else{
            if let data = diskCache.get(key) {
                if let img =  UIImage(data: data) {
                   transformDisplayCacheImage(img)
                    return true
                }
            }

        }

        return false
    }
    
    func updateImageFromCache() -> Bool {
        let cache = Guiso.get().getMemoryCache()
        let cacheGif = Guiso.get().getMemoryCacheGif()
        let diskCache = Guiso.get().getDiskCache()
        let diskCacheGif = Guiso.get().getDiskCacheObject()

        if mOptions.getAsGif(){
             if let gifDrawable =  cacheGif.get(mKey) {
                    displayInTarget(gifDrawable)
                     return true
            }
            if let obj = diskCacheGif.get(mKey) {
                if let gif = obj as? Gif{
                    displayInTarget(gif)
                    if !mOptions.getSkipMemoryCache() { cacheGif.add(mKey, val: gif,isUpdate: false) }
                    return true
                }
            }
                 
        }else{
            
            if let img =  cache.get(mKey) {
                   displayInTarget(img)
                    return true
            }
            
            if let data = diskCache.get(mKey) {
                if let img =  UIImage(data: data) {
                     displayInTarget(img)
                    if !mOptions.getSkipMemoryCache() { cache.add(mKey, val: img, isUpdate: false) }
                    return true
                }
            }

        }

        return false
    }
    
    func displayInTarget(_ img:UIImage){
        DispatchQueue.main.async {
            if !self.mIsCancelled {
                self.mTarget?.onThumbReady(img)
            }
        }
    }
    func displayInTarget(_ gif: Gif){
       DispatchQueue.main.async {
        if  !self.mIsCancelled {
            let layer = GifLayer(gif)
            self.mTarget?.onThumbReady(layer)
           }
       }
    }
    func onLoadFailed(){
        DispatchQueue.main.async {
            if !self.mIsCancelled {
                self.mOptions.getErrorHolder()?.setTarget(self.mTarget)
                self.mOptions.getErrorHolder()?.load(true)
            }
        }
    }
    

    
    func pause(){
        mLoader.pause()
    }
    
    func resume(){
         mLoader.resume()
    }
    
    private var mIsCancelled = false
    func cancel(){
        mIsCancelled = true
        mLoader.cancel()
        mTask?.cancel()
        mTask = nil
    }
}
