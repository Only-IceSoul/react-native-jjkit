//
//  GuisoPreload.swift
//  JJGuiso
//
//  Created by Juan J LF on 10/26/20.
//

import UIKit

class GuisoPreload : Runnable {

    private var mModel: Any?
    private var mLoader : LoaderProtocol!
    private var mKey : String = ""
    private var mOptions : GuisoOptions!
    private var mTransformer: GuisoTransform!
    private var mScale : Guiso.ScaleType!
    private var mAnimImgDecoder : AnimatedImageDecoderProtocol!
    private var mSaver:GuisoSaver!
    private var mPrimarySignature = ""
    init(model:Any?,_ primarySignature:String,options:GuisoOptions, loader: LoaderProtocol,animImgDecoder : AnimatedImageDecoderProtocol) {
        mOptions = options
        mPrimarySignature = primarySignature
        mModel = model
        mAnimImgDecoder = animImgDecoder
            
        mLoader = loader
        mScale = mOptions.getScaleType()  == .none ? getScaleTypeFrom( .scaleAspectFit) : mOptions.getScaleType()
        let key = makeKey()
        mKey = key.toString()
        mTransformer = GuisoTransform(scale: mScale, l: mOptions.getLanczos())
        mSaver = GuisoSaver()
        
    }
    
    private var mTask: DispatchWorkItem?
    public func setTask(_ t:DispatchWorkItem){
        mTask = t
    }
    
    func getKey() -> String{
        return mKey
    }

   
    
    public func run(){
        if !checkIfNeedIgnore() {
             registry()
            if !updateImageFromCache()  {

                mLoader.loadData(model: mModel, width: mOptions.getWidth(), height: mOptions.getHeight(), options: mOptions) { (result, type,error,dataSource) in
                    if Thread.isMainThread {
                        Guiso.get().getExecutor().doWork {
                            if self.mOptions.getAsAnimatedImage() {
                                self.handleAnimImg(result, type: type,error,dataSource)
                            }else{
                                self.handleImage(result,type:type,error,dataSource)
                            }
                        }
                    }else{
                        if self.mOptions.getAsAnimatedImage() {
                           self.handleAnimImg(result, type: type,error,dataSource)
                        }else{
                           self.handleImage(result,type:type,error,dataSource)
                        }
                    }
                  
                }

            } //cache

        }
        
    }
    func handleImage(_ result:Any?,type:Guiso.LoadType,_ error:String,_ dataSource: Guiso.DataSource){
        if type == .data {
           
            guard let data = result as? Data
                else {
                self.onLoadFailed("Data to image ,loader error -> \(error)")
                    return
            }
           
            guard let img = UIImage(data: data) else {
                self.onLoadFailed("Data to image ,loader error -> maybe its not a static image")
                return
                
            }
            
            
             saveData(img,dataSource)
            transformDisplayCacheImage(img,dataSource)
            
        }
    
        if type == .uiimg{
            guard let img = result as? UIImage
               else {
                  self.onLoadFailed("UIImage result cast ,loader error -> \(error)")
                   return
            }
            saveData(img,dataSource)
            transformDisplayCacheImage(img,dataSource)
        }
    }
    
 
    func handleAnimImg(_ result:Any?,type:Guiso.LoadType,_ error:String,_ dataSource: Guiso.DataSource){
        if type == .data {
          guard let data = result as? Data
           else {
            self.onLoadFailed("decoding gif, loader error -> \(error)")
              return
          }
            guard let gif = self.mAnimImgDecoder.decode(data:data) else{
                self.onLoadFailed("decoding gif, loader error -> bad request, maybe its not a animated image")
                return
            }
             saveData(gif,dataSource)
             transformDisplayCacheGif(gif,dataSource)
        
        }
        if type == .uiimg {
            guard let img = result as? UIImage
              else{
                self.onLoadFailed("getting gift from uiimage, loader error -> \(error)")
                  return
            }
            
            self.onLoadFinished()
            saveResource(img,dataSource,false)
            
        }
        if type == .animatedImg {
            guard let gif = result as? AnimatedImage
            else {
              self.onLoadFailed("error: casting any to gif")
                return
            }
            saveData(gif,dataSource)
            transformDisplayCacheGif(gif,dataSource)
        }
        
    }
    
    

    func transformDisplayCacheImage(_ img: UIImage,_ dataSource:Guiso.DataSource){
        var isTransformed = false
        var final: UIImage? = img
        if self.mOptions.getIsOverride() {
            isTransformed = true
        final = self.mTransformer.transformImage(img: img, outWidth: mOptions.getWidth(), outHeight: mOptions.getHeight())
        }
        if self.mOptions.getTransformer() != nil {
            isTransformed = true
        final  = self.mOptions.getTransformer()?.transformImage(img: img, outWidth: mOptions.getWidth(), outHeight: mOptions.getHeight())
        }
        if final != nil {
            self.onLoadFinished()
            saveToMemoryCache(final!)
            saveResource(final!,dataSource,isTransformed)
        }else{
            self.onLoadFailed("failed transformation")
        }
    }

    func transformDisplayCacheGif(_ gifObj:AnimatedImage,_ dataSource:Guiso.DataSource){
        let gif = gifObj
        var isTransformed = false
        if self.mOptions.getIsOverride() {
            isTransformed = true
            var images = [CGImage]()
            gif.frames.forEach { (cg) in
             let i = self.mTransformer.transformGif(cg: cg, outWidth: self.mOptions.getWidth(), outHeight: self.mOptions.getHeight())
                if i != nil { images.append(i!) }
            }
            gif.frames = images
        }

        if self.mOptions.getTransformer() != nil {
            isTransformed = true
            var images = [CGImage]()
            gif.frames.forEach { (cg) in
                let i = self.mOptions.getTransformer()!.transformGif(cg: cg, outWidth: self.mOptions.getWidth(), outHeight: self.mOptions.getHeight())
                if i != nil { images.append(i!) }
            }
            gif.frames = images
        }

        let drawable = TransformationUtils.cleanGif(gif)
        self.onLoadFinished()
        saveToMemoryCache(gif)
        saveResource(drawable,dataSource,isTransformed)
        
    }

   
    
    private func saveData(_ img:UIImage,_ dataSource:Guiso.DataSource){
        if mKey.isEmpty { return }
        let st =  mOptions.getDiskCacheStrategy()
        if st == .data && dataSource != .dataDiskCache {
            
            self.mSaver.saveToDiskCache(key: sourceKey().toString(), image: img)
        }
        if st == .automatic ||  st == .all &&  dataSource == .remote {
           self.mSaver.saveToDiskCache(key: sourceKey().toString(), image: img)
            
        }
        
    }
    private func saveData(_ gif:AnimatedImage,_ dataSource:Guiso.DataSource){
        if mKey.isEmpty { return }
        let st =  mOptions.getDiskCacheStrategy()
        if st == .data && dataSource != .dataDiskCache {
            self.mSaver.saveToDiskCache(key: sourceKey().toString(),gif: gif)
        }
        if st == .automatic ||  st == .all &&  dataSource == .remote {
            self.mSaver.saveToDiskCache(key: sourceKey().toString(),gif: gif)
        }
    }
    
    private func saveResource(_ img:UIImage,_ dataSource:Guiso.DataSource,_ isTransformed:Bool){
        if mKey.isEmpty { return }
       let st =  mOptions.getDiskCacheStrategy()
        
        if st == .resource || st == .all && dataSource != .memoryCache
            && dataSource != .resourceDiskCache {
           self.mSaver.saveToDiskCache(key: mKey, image: img)
           
       }
        if st == .automatic && isTransformed {
            self.mSaver.saveToDiskCache(key: mKey, image: img)
        }
       
    }
    private func saveResource(_ gif:AnimatedImage,_ dataSource:Guiso.DataSource,_ isTransformed:Bool){
        if mKey.isEmpty { return }
       let st =  mOptions.getDiskCacheStrategy()
        if st == .resource || st == .all && dataSource != .memoryCache
        && dataSource != .resourceDiskCache {
           self.mSaver.saveToDiskCache(key: mKey,gif: gif)
       }
        if st == .automatic && isTransformed {
            self.mSaver.saveToDiskCache(key: mKey,gif: gif)
        }
    }
    
    private func saveToMemoryCache(_ img:UIImage){
        let sm = mOptions.getSkipMemoryCache()
        if !sm { self.mSaver.saveToMemoryCache(key: mKey, image: img)}
    }
    
    private func saveToMemoryCache(_ gif:AnimatedImage){
        let sm = mOptions.getSkipMemoryCache()
        if !sm { self.mSaver.saveToMemoryCache(key: mKey, gif:gif) }
    }
    
   
    
    func makeKey() -> Key {
        let key = mOptions.getIsOverride() ? Key(signature:mPrimarySignature ,extra:mOptions.getSignature(), width: mOptions.getWidth(), height: mOptions.getHeight(), scaleType: mScale, frame: mOptions.getFrameSecond()   ,exactFrame:mOptions.getExactFrame(), isAnim:mOptions.getAsAnimatedImage(), transform: mOptions.getTransformerSignature()) :
            Key(signature:mPrimarySignature,extra: mOptions.getSignature(), width: -1, height: -1, scaleType: .none,frame: mOptions.getFrameSecond()  ,exactFrame:mOptions.getExactFrame(), isAnim: mOptions.getAsAnimatedImage(),
        transform: mOptions.getTransformerSignature())
        return key
    }
    
    func sourceKey() -> Key {
        return  Key(signature: mPrimarySignature, extra: mOptions.getSignature(), width: -1, height: -1, scaleType: .none,frame: mOptions.getFrameSecond()  ,exactFrame:mOptions.getExactFrame(), isAnim: mOptions.getAsAnimatedImage(),
        transform: "")
    }
    private func getScaleTypeFrom(_ scale:UIView.ContentMode)-> Guiso.ScaleType{
        return scale == UIView.ContentMode.scaleAspectFill ? .centerCrop : .fitCenter
    }
    
    //should update disk cache if convertion to gif or image fail?
    func updateImageFromCache() -> Bool {
        let cache = Guiso.get().getMemoryCache()
        let cacheGif = Guiso.get().getMemoryCacheGif()
        let diskCache = Guiso.get().getDiskCache()
    
        let diskStrategy = mOptions.getDiskCacheStrategy()
        let skipCache = mOptions.getSkipMemoryCache()
        let keyD = sourceKey().toString()

        if mOptions.getAsAnimatedImage(){
            if !skipCache {
                if cacheGif.get(mKey) != nil {
                    onLoadFinished()
                     return true
                }
            }
            if diskStrategy != .none {
                if let obj = diskCache.getClassObj(mKey) {
                    if let gif = obj as? AnimatedImage{
                        onLoadFinished()
                        if !skipCache {
                            cacheGif.add(mKey, val: gif,isUpdate: false)
                            
                        }
                        return true
                    }
                }
                
                if let obj = diskCache.getClassObj(keyD) {
                    if let gif = obj as? AnimatedImage{
                        handleAnimImg(gif, type: .animatedImg, "",.dataDiskCache)
                        return true
                    }
                }
            }
          
                 
        }else{
            
            if !skipCache , cache.get(mKey) != nil {
                onLoadFinished()
                    return true
            }
            
            if diskStrategy != .none {
                  if let data = diskCache.get(mKey) {
            
                        if let img =  UIImage(data: data) {
                             onLoadFinished()
                            if !skipCache {
                                cache.add(mKey, val: img, isUpdate: false)
                                
                            }
                            return true
                        }
                  }
                
                if let data = diskCache.get(keyD) {
                    if let img =  UIImage(data: data) {
                        handleImage(img, type: .uiimg, "",.dataDiskCache)
                        return true
                    }
                }
            }
            
            
            

        }

        return false
    }
    
    func registry(){
        GuisoRequestManager.registryPreLoad(mKey)
    }
    
    func checkIfNeedIgnore() -> Bool {
        return GuisoRequestManager.containsPreload(mKey) || mKey.isEmpty
    }
    
    
    func onLoadFinished(){
        GuisoRequestManager.removePreload(mKey)
    }

    func onLoadFailed(_ msg:String){
        GuisoRequestManager.removePreload(mKey)
    }
    
    public func pause(){
        mLoader.pause()
    }
    
    public func resume(){
         mLoader.resume()
    }
    
    private var mIsCancelled = false
    public func cancel(){
        mIsCancelled = true
        mLoader.cancel()
        mTask?.cancel()
        mTask = nil
    }
}
