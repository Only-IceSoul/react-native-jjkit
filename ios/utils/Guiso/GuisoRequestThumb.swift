//
//  GuisoRequestThumb.swift
//  JJGuiso
//
//  Created by Juan J LF on 10/26/20.
//

import UIKit

public class GuisoRequestThumb: Runnable,Equatable,Request {
 

    

    private var mModel: Any?
    private var mLoader : LoaderProtocol!
    private weak var mTarget : ViewTarget?
    private var mKey : Key!
    private var mOptions : GuisoOptions!
    private var mScale : Guiso.ScaleType!
    private var mAnimImgDecoder : AnimatedImageDecoderProtocol!
    private var mPrimarySignature = ""

    init(model:Any?,_ primarySignature:String,options:GuisoOptions,_ target: ViewTarget?, loader: LoaderProtocol,animImgDecoder : AnimatedImageDecoderProtocol) {
        pthread_rwlock_init(&mLock, nil)
        mOptions = options
        mPrimarySignature = primarySignature
        mModel = model
        mAnimImgDecoder = animImgDecoder
            
        mTarget = target
        mLoader = loader
        mScale = mOptions.getScaleType()  == .none ? getScaleTypeFrom(mTarget?.getContentMode() ?? .scaleAspectFit) : mOptions.getScaleType()
    
        mKey = makeKey()
        
    }
    
    deinit {
        pthread_rwlock_destroy(&mLock)
    }
    
    private var mTask: DispatchWorkItem?
    public func setTask(_ t:DispatchWorkItem){
        mTask = t
    }
    


 
    public func run(){
        
        
        //diskcache
        if mOptions.getAsAnimatedImage() {
            if let res = loadFromDiskAnim() {
                onResourceReady(res, .resourceDiskCache)
                if !mOptions.getSkipMemoryCache() {
                    Guiso.get().getMemoryCacheGif().add(mKey, val: res)
                }
                return
            }
        }else{
            if let res = loadFromDiskImg() {
                onResourceReady(res, .resourceDiskCache)
                if !mOptions.getSkipMemoryCache() {
                    Guiso.get().getMemoryCache().add(mKey, val: res)
                }
                return
            }
        }
        
        if isCancelled { return  }
        
        //source
        if mOptions.getAsAnimatedImage() {
            if let res = loadFromDiskAnimSource() {
                self.handleAnimImg(res, type: .animatedImg,"",.dataDiskCache)
                return
            }
        }else{
            if let res = loadFromDiskImgSource() {
                self.handleImage(res,type:.uiimg,"",.dataDiskCache)
                return
            }
        }

        if isCancelled { return  }
        //fetcher
        mLoader.loadData(model: mModel, width: mOptions.getWidth(), height: mOptions.getHeight(), options: mOptions) { (result, type,error,dataSource) in
            
            if self.isCancelled { return  }
            
            if Thread.isMainThread  {
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
        


        
    }
    func handleImage(_ result:Any?,type:Guiso.LoadType,_ error:String,_ dataSource: Guiso.DataSource){
        if type == .data {
           
            guard let data = result as? Data
                else {
                self.onLoadFailedError("Data to image ,loader error -> \(error)")
                    return
            }
           
            guard let img = UIImage(data: data) else {
                self.onLoadFailedError("Data to image ,loader error -> maybe its not a static image")
                return
                
            }
            
             if isCancelled { return  }
             saveData(img,dataSource)
             transformDisplayCacheImage(img,dataSource)
            
        }
    
        if type == .uiimg{
            guard let img = result as? UIImage
               else {
                  self.onLoadFailedError("UIImage result cast ,loader error -> \(error)")
                   return
            }
            if isCancelled { return  }
            saveData(img,dataSource)
            transformDisplayCacheImage(img,dataSource)
        }
    }
    
 
    func handleAnimImg(_ result:Any?,type:Guiso.LoadType,_ error:String,_ dataSource: Guiso.DataSource){
        if type == .data {
          guard let data = result as? Data
           else {
            self.onLoadFailedError("decoding gif, loader error -> \(error)")
              return
          }
            guard let gif = self.mAnimImgDecoder.decode(data:data) else{
                self.onLoadFailedError("decoding gif, loader error -> bad request, maybe its not a animated image")
                return
            }
            if isCancelled { return  }
             saveData(gif,dataSource)
             transformDisplayCacheAnim(gif,dataSource)
        
        }
        if type == .uiimg {
            guard let img = result as? UIImage
              else{
                self.onLoadFailedError("getting gift from uiimage, loader error -> \(error)")
                  return
            }
            if isCancelled { return  }
            saveData(img,dataSource)
            onResourceReady(img, dataSource)
           
            
        }
        if type == .animatedImg {
            guard let gif = result as? AnimatedImage
            else {
              self.onLoadFailedError("error: casting any to gif")
                return
            }
            if isCancelled { return  }
            saveData(gif,dataSource)
            transformDisplayCacheAnim(gif,dataSource)
        }
        
    }
    
    

    func transformDisplayCacheImage(_ img: UIImage,_ dataSource:Guiso.DataSource){
        var isTransformed = false
        var final: UIImage? = img
        if self.mOptions.getIsOverride() {
            isTransformed = true
        final = GuisoTransform.transformImage(img: img, outWidth: mOptions.getWidth(), outHeight: mOptions.getHeight(),scale:mOptions.getScaleType()  == .none ? .fitCenter : mOptions.getScaleType(),l: mOptions.getLanczos())
        }
        if self.mOptions.getTransformer() != nil {
            isTransformed = true
        final  = self.mOptions.getTransformer()?.transformImage(img: img, outWidth: mOptions.getWidth(), outHeight: mOptions.getHeight())
        }
        if isCancelled { return  }
        if final != nil {
            onResourceReady(final,dataSource)
            saveToMemoryCache(final!)
            saveResource(final!,dataSource,isTransformed)
        }else{
            self.onLoadFailedError("failed transformation")
        }
    }

    func transformDisplayCacheAnim(_ gifObj:AnimatedImage,_ dataSource:Guiso.DataSource){
        let gif = gifObj
        var isTransformed = false
        if self.mOptions.getIsOverride() {
            isTransformed = true
            var images = [CGImage]()
            gif.frames.forEach { (cg) in
             let i = GuisoTransform.transformGif(cg: cg, outWidth: self.mOptions.getWidth(), outHeight: self.mOptions.getHeight(),scale:mOptions.getScaleType()  == .none ? .fitCenter : mOptions.getScaleType(),l: mOptions.getLanczos())
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
        if isCancelled { return  }
        let drawable = TransformationUtils.cleanGif(gif)
        onResourceReady(drawable,dataSource)
        saveToMemoryCache(gif)
        saveResource(drawable,dataSource,isTransformed)
        
    }

   
    
    private func saveData(_ img:UIImage,_ dataSource:Guiso.DataSource){
        if mKey.isValidSignature() == false { return }
        let st =  mOptions.getDiskCacheStrategy()
        if st == .data && dataSource != .dataDiskCache {
            
            GuisoSaver.saveToDiskCache(key: sourceKey(), image: img)
        }
        if st == .automatic ||  st == .all &&  dataSource == .remote {
            GuisoSaver.saveToDiskCache(key: sourceKey(), image: img)
            
        }
        
    }
    private func saveData(_ gif:AnimatedImage,_ dataSource:Guiso.DataSource){
        if mKey.isValidSignature() == false { return }
        let st =  mOptions.getDiskCacheStrategy()
        if st == .data && dataSource != .dataDiskCache {
            GuisoSaver.saveToDiskCache(key: sourceKey(),gif: gif)
        }
        if st == .automatic ||  st == .all &&  dataSource == .remote {
            GuisoSaver.saveToDiskCache(key: sourceKey(),gif: gif)
        }
    }
    
    private func saveResource(_ img:UIImage,_ dataSource:Guiso.DataSource,_ isTransformed:Bool){
        if mKey.isValidSignature() == false { return }
       let st =  mOptions.getDiskCacheStrategy()
        
        if st == .resource || st == .all && dataSource != .memoryCache
            && dataSource != .resourceDiskCache {
            GuisoSaver.saveToDiskCache(key: mKey, image: img)
           
       }
        if st == .automatic && isTransformed {
            GuisoSaver.saveToDiskCache(key: mKey, image: img)
        }
       
    }
    private func saveResource(_ gif:AnimatedImage,_ dataSource:Guiso.DataSource,_ isTransformed:Bool){
        if mKey.isValidSignature() == false { return }
       let st =  mOptions.getDiskCacheStrategy()
        if st == .resource || st == .all && dataSource != .memoryCache
        && dataSource != .resourceDiskCache {
            GuisoSaver.saveToDiskCache(key: mKey,gif: gif)
       }
        if st == .automatic && isTransformed {
            GuisoSaver.saveToDiskCache(key: mKey,gif: gif)
        }
    }
    
    private func saveToMemoryCache(_ img:UIImage){
        if mKey.isValidSignature() == false { return }
        let sm = mOptions.getSkipMemoryCache()
        if !sm { GuisoSaver.saveToMemoryCache(key: mKey, image: img)}
    }
    
    private func saveToMemoryCache(_ gif:AnimatedImage){
        if mKey.isValidSignature() == false { return }
        let sm = mOptions.getSkipMemoryCache()
        if !sm { GuisoSaver.saveToMemoryCache(key: mKey, gif:gif) }
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
    


    var isCancelled = false
    
    private func cancel(){
        isCancelled = true
        mLoader.cancel()
        mTask?.cancel()
        mTask = nil
    }
    
    
    private var resourceImg :UIImage?
    private var resourceAnimImg: AnimatedImage?
    
    public func clear(){
        if status == .cleared {  return  }
        cancel()
        
        resourceImg = nil
        resourceAnimImg = nil
        status = .cleared
    }
    
 
    
    public func begin(){
        pthread_rwlock_wrlock(&mLock); defer { pthread_rwlock_unlock(&mLock) }
        if mModel == nil {
            mOptions.getFallbackHolder()?.load(mTarget)
            onLoadFailedFallback("Model is nil")
            return
        }
        
        if status == .running {
            return
        }
        
        if status == .complete {
            if mOptions.getAsAnimatedImage() {
                onResourceReady(resourceAnimImg,Guiso.DataSource.memoryCache)
            }else{
                onResourceReady(resourceImg,Guiso.DataSource.memoryCache)
            }
            return
        }
        
        mOptions.getPlaceHolder()?.load(mTarget)
        
        load()
        
        
        
        
        
    
    }
    
    func load(){
        status = .running
        
        if isCancelled { return  }
        //from memory
        if mOptions.getAsAnimatedImage() {
            if let res = loadFromMemoryAnim() {
                onResourceReady(res, .memoryCache)
                return
            }
        }else{
            if let res = loadFromMemoryImg() {
                onResourceReady(res, .memoryCache)
                return
            }
        }
        
        if isCancelled { return  }
        mTask = Guiso.get().getExecutor().doWork(self, priority: .userInitiated, flags: .enforceQoS)
        
        
    }
    
   
    
    func loadFromDiskImgSource() -> UIImage?{
        let diskCache = Guiso.get().getDiskCache()
        let diskStrategy = mOptions.getDiskCacheStrategy()
        let keyD = sourceKey()
        if diskStrategy != .none{
            if let data = diskCache.get(keyD) {
                if let img =  UIImage(data: data) {
                    return img
                }
            }
        }
    
        return nil
    }
    
    func loadFromDiskAnimSource() -> AnimatedImage?{
        let diskCache = Guiso.get().getDiskCache()
        let diskStrategy = mOptions.getDiskCacheStrategy()
        let keyD = sourceKey()
        if diskStrategy != .none {
            if let obj = diskCache.getClassObj(keyD) {
                if let drawable = obj as? AnimatedImage{
                    return drawable
                }
            }
            
        }
        return nil
    }
    
    func loadFromDiskImg() -> UIImage?{
        let diskCache = Guiso.get().getDiskCache()
        let diskStrategy = mOptions.getDiskCacheStrategy()
        if diskStrategy != .none {
              if let data = diskCache.get(mKey) {
                    if let img =  UIImage(data: data) {
                        return img
                    }
              }
        }
        return nil
    }
    
    func loadFromDiskAnim() -> AnimatedImage?{
        let diskCache = Guiso.get().getDiskCache()
        let diskStrategy = mOptions.getDiskCacheStrategy()
        if diskStrategy != .none {
            if let obj = diskCache.getClassObj(mKey) {
                if let gif = obj as? AnimatedImage{
                    let drawable = TransformationUtils.cleanGif(gif)
                    return drawable
                }
            }
        }
        return nil
    }
    
    func loadFromMemoryImg() -> UIImage?{
        let cache = Guiso.get().getMemoryCache()
        let skipCache = mOptions.getSkipMemoryCache()
        
        if !skipCache ,let img =  cache.get(mKey)  {
                return img
        }
        return nil
    }
    
    func loadFromMemoryAnim() -> AnimatedImage?{
        let cache = Guiso.get().getMemoryCacheGif()
        let skipCache = mOptions.getSkipMemoryCache()
        if !skipCache {
            if let animImg =  cache.get(mKey) {
                 return animImg
            }
        }
        return nil
    }
    
    func onResourceReady(_ res:UIImage?,_ dataSource:Guiso.DataSource){
        if res == nil {
            onLoadFailedError("expected recieve a object uiimage but instead got nil, datasource: \(dataSource)")
            return
        }
        status = .complete
        if mTarget == nil {
            resourceImg = nil
            resourceAnimImg = nil
            return
        }
        
        resourceImg = res
        resourceAnimImg = nil
        
        if !self.isCancelled {
            DispatchQueue.main.async {
                self.mTarget?.onResourceReady(res!)
                self.mTask = nil
            }
        }
    }
    func onResourceReady(_ res:AnimatedImage?,_ dataSource:Guiso.DataSource){
        if res == nil {
            onLoadFailedError("expected recieve a object animatedImage but instead got nil, datasource: \(dataSource)")
            return
        }
        status = .complete
        if mTarget == nil {
            resourceImg = nil
            resourceAnimImg = nil
            return
        }
        
        resourceAnimImg = res
        resourceImg = nil
        
        if !self.isCancelled {
            DispatchQueue.main.async {
                
                let layer = AnimatedLayer(res!)
                self.mTarget?.onResourceReady(layer)
                self.mTask = nil
            }
        }
        
    }
    
    func onLoadFailedError(_ msg:String){
        status = .failed
        if !self.isCancelled {
            self.mTask = nil
        }
    }
    func onLoadFailedFallback(_ msg:String){
        status = .failed
        if !self.isCancelled {
            self.mTask = nil
      
        }
    }
    
    
    
    private var status: Status = .pending
    private var mLock = pthread_rwlock_t()
    
    public func isComplete() -> Bool {
        pthread_rwlock_rdlock(&mLock); defer { pthread_rwlock_unlock(&mLock) }
        return status == .complete
    }
    public func isRunning() -> Bool {
        pthread_rwlock_rdlock(&mLock); defer { pthread_rwlock_unlock(&mLock) }
        return status == .running || status == .waitingSize
    }
    public func isCleared() -> Bool {
        pthread_rwlock_rdlock(&mLock); defer { pthread_rwlock_unlock(&mLock) }
        return status == .cleared
    }
    enum Status {
        case complete, //finished loading media successfully
             running, // in the process of fetching media
             pending, // created but not yet running
             waitingSize,
            
             failed, // failed to load media, may be restarted
             cleared
    }
    
    
    public static func == (lhs: GuisoRequestThumb, rhs: GuisoRequestThumb) -> Bool {
       return lhs.mKey == rhs.mKey
        && lhs.mOptions == rhs.mOptions
       
    
    }
}
