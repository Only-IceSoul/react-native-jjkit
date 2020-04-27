//
//  GuisoLoader.swift
//  AnimationPractica
//
//  Created by Juan J LF on 4/23/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit
import Photos


class GuisoLoader {
    
    private var mKey: String!
    private var mTarget : ViewTarget?
    private var mMemoryCache : Bool!
    private var mUrl : String!
    private var mDiskCacheStrategy = Guiso.DiskCacheStrategy.none
    private var mReqW: CGFloat = 0
    private var mReqH: CGFloat = 0
    private var mSecond : Double = 0
    private var mScaleType: Guiso.ScaleType
    private var mMediaType : Guiso.MediaType!
    private var mExtension = "jpeg"
    private var mLanczos = false
    init(_ request: GuisoRequestBuilder,_ target:ViewTarget) {
        mUrl = request.getUrl()
        mTarget = target
        mReqH = request.getHeight()
        mReqW = request.getWidth()
        mReqW = mReqW > 20 ? mReqW : 20
        mReqH = mReqH > 20 ? mReqH : 20
        mMemoryCache = !request.getSkipMemoryCache()
        mSecond = request.getFrameSecond()
        mScaleType = request.getScaleType()
        mMediaType = request.getMediaType()
        let key = makeKey(request.getIsOverride())
        mKey = key.toString()
        mExtension = key.getExtension()
        mDiskCacheStrategy = request.getDiskCacheStrategy()
        mLanczos = request.getLanczos()
    }
    
    func updateIdentifier(){
        self.mTarget!.setIdentifier(mKey)
    }
    
    func getIdentifier() -> String {
        return self.mTarget!.getIdentifier()
    }
    

    
    func getImageWidth(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    
    func updateTargetResize(){
        if let asset = getAsset(identifier: mUrl){
            ImageHelper.getImage(asset:asset) {  (fullSize) in
                   if fullSize != nil {
                       if let resized = self.resizeImage(fullSize!){
                           self.displayInTarget(resized)
                           if self.mMemoryCache == true { self.saveToMemoryCache(resized) }
                           self.saveToDiskCache(resized)
                       } else { self.onLoadFailed()
                            print("failed image resize")
                       }
                   } else { self.onLoadFailed()
                        print("failed image fullsize")
                   }
            }
        }else { self.onLoadFailed() }
       
    }
    
    func updateTargetResizeManager(){
       if let asset = getAsset(identifier: mUrl){
           ImageHelper.getImage(asset: asset, size: CGSize(width: mReqW, height: mReqH), contentMode: getPHContentMode(mScaleType)){  (resized) in
                  if resized != nil {
                     
                  self.displayInTarget(resized!)
                  if self.mMemoryCache == true { self.saveToMemoryCache(resized!) }
                  self.saveToDiskCache(resized!)
             
                  } else { self.onLoadFailed() }
           }
       }else { self.onLoadFailed() }
      
   }
    
    func updateTargetFullSize(){
          if let asset = getAsset(identifier: mUrl){
            ImageHelper.getImage(asset:asset) { (fullSize) in
                if fullSize != nil {
                    self.displayInTarget(fullSize!)
                    if self.mMemoryCache == true { self.saveToMemoryCache(fullSize!) }
                 //   self.saveToDiskCache(fullSize!)
                } else { self.onLoadFailed() }
            }
        }
    }

    func updateTargetResizeVideo(){
         if let asset = getAsset(identifier: mUrl){
            ImageHelper.getVideoThumbnail(asset, second: mSecond) { (fullSize, error) in
                if error != nil {
                    self.onLoadFailed()
                    print("error en video getimage : ",error!)
                    return
                }
                if fullSize != nil {
                    if let resized = self.resizeImage(fullSize!){
                        self.displayInTarget(resized)
                        if self.mMemoryCache == true { self.saveToMemoryCache(resized) }
                        self.saveToDiskCache(resized)
                    }else { self.onLoadFailed()}
                }else { self.onLoadFailed()}
            }
        }else { self.onLoadFailed()}
    }

    func updateTargetFullSizeVideo(){
         if let asset = getAsset(identifier: mUrl){
            ImageHelper.getVideoThumbnail(asset, second: mSecond) { (fullSize, error) in
               if error != nil {
                   self.onLoadFailed()
                   print("error en video getimage : ",error!)
                   return
               }
               if fullSize != nil {
                       self.displayInTarget(fullSize!)
                       if self.mMemoryCache { self.saveToMemoryCache(fullSize) }
                     //  self.saveToDiskCache(fullSize!)
               }else { self.onLoadFailed() }
            }
        }else { self.onLoadFailed() }
    }
    
    func updateTargetResizeGif(){
         if let asset = getAsset(identifier: mUrl){
            ImageHelper.getImageData(asset: asset) { (data) in
                if data != nil {
                    if let gif = ImageHelper.makeGif(data!, self.mReqW, self.mReqH, self.mScaleType,lanczos:self.mLanczos){
                        let drawable = ImageHelper.getGifDrawable(gif)
                        self.displayInTarget(drawable)
                        if self.mMemoryCache { self.saveToMemoryCache(drawable) }
                        self.saveToDiskCache(gif)
                  }else { self.onLoadFailed() }
                }else { self.onLoadFailed() }
            }
        }else { self.onLoadFailed() }
    }

    
    func updateTargetFullSizeGif(){
         if let asset = getAsset(identifier: mUrl){
            ImageHelper.getImageData(asset: asset) { (data) in
                if data != nil {
                    if let gif = ImageHelper.makeGif(data!){
                        let drawable = ImageHelper.getGifDrawable(gif)
                        self.displayInTarget(drawable)
                        if self.mMemoryCache { self.saveToMemoryCache(drawable) }
                      //  self.saveToDiskCache(gif)
                    }else { self.onLoadFailed() }
                }else { self.onLoadFailed() }
            }
        }
    }
    
  
    func updateTargetResizeAudio(){
            if let fullSize  = ImageHelper.getAudioArtWork(mUrl) {
                if let resized = self.resizeImage(fullSize){
                    self.displayInTarget(resized)
                    if self.mMemoryCache { self.saveToMemoryCache(resized) }
                    self.saveToDiskCache(resized)
                }else { self.onLoadFailed() }
            }else { self.onLoadFailed() }
        
   }
    
    func updateTargetFullSizeAudio(){
            if let fullSize = ImageHelper.getAudioArtWork(mUrl) {
                    self.displayInTarget(fullSize)
                    if self.mMemoryCache { self.saveToMemoryCache(fullSize) }
                    //self.saveToDiskCache(fullSize!)
            }else { self.onLoadFailed() }
    }
    func updateTargetResizeWebGif(){
         let web = URL(string: mUrl)
        URLSession.shared.dataTask(with: web!) { (data, response, error) in
            if error != nil {
                print("ImageWorker:error - updateWebImage -> ",error!)
                self.onLoadFailed()
                return
            }
            if data != nil {
                if let gif = ImageHelper.makeGif(data!, self.mReqW, self.mReqH, self.mScaleType,lanczos: self.mLanczos){
                    let drawable = ImageHelper.getGifDrawable(gif)
                    self.displayInTarget(drawable)
                    if self.mMemoryCache { self.saveToMemoryCache(drawable) }
                    self.saveToDiskCache(gif)
                } else { self.onLoadFailed() }
            }  else { self.onLoadFailed() }
        }.resume()
    }

    func updateTargetFullSizeWebGif(){
        let web = URL(string: mUrl)
        URLSession.shared.dataTask(with: web!) { (data, response, error) in
            if error != nil {
                print("ImageWorker:error - updateWebImage -> ",error!)
                self.onLoadFailed()
                return
            }
            if data != nil {
               
               if let gif = ImageHelper.makeGif(data!){
                    let drawable = ImageHelper.getGifDrawable(gif)
                    self.displayInTarget(drawable)
                    if self.mMemoryCache { self.saveToMemoryCache(drawable) }
                    self.saveToDiskCache(gif)
               }else { self.onLoadFailed() }
            }else { self.onLoadFailed() }
        }.resume()
    }

   
    
    func updateTargetResizeWeb(){
        let web = URL(string: mUrl)
        URLSession.shared.dataTask(with: web!) { (data, response, error) in
            if error != nil {
                print("ImageWorker:error - updateWebImage -> ",error!)
                self.onLoadFailed()
                return
            }
            if data != nil {
                if let fullSize = self.getImageWidth(data: data!){
                    if let resized = self.resizeImage(fullSize){
                        self.displayInTarget(resized)
                        if self.mMemoryCache { self.saveToMemoryCache(resized) }
                        self.saveToDiskCache(resized)
                    }else { self.onLoadFailed() }
                }else { self.onLoadFailed() }
            }else { self.onLoadFailed() }
        }.resume()
    }

    func updateTargetFullSizeWeb(){
        let web = URL(string: mUrl)
        URLSession.shared.dataTask(with: web!) { (data, response, error) in
        
            if error != nil {
                print("ImageWorker:error - updateWebImage -> ",error!)
                self.onLoadFailed()
                return
            }
            if data != nil {
                if let fullSize = self.getImageWidth(data: data!){
                    self.displayInTarget(fullSize)
                    if self.mMemoryCache { self.saveToMemoryCache(fullSize) }
                    self.saveToDiskCache(fullSize)
                }else { self.onLoadFailed() }
            }else { self.onLoadFailed() }
        }.resume()
    }
   

    func saveToMemoryCache(_ img:UIImage?){
         if img == nil { return  }
         let cache = Guiso.get().getMemoryCache()
         cache.add(mKey, val: img!)
    }
    
    func saveToMemoryCache(_ gif:GifDrawable?){
       if gif == nil { return  }
       let cache = Guiso.get().getMemoryCacheGif()
        cache.add(mKey, val: gif!)
    }
    
    func saveToDiskCache(_ image:UIImage){
        //manage strategys
        let diskCache = Guiso.get().getDiskCache()
        if mDiskCacheStrategy == .automatic {
          if let data = makeImageData(image, format: mExtension){
                diskCache.add(mKey, data: data)
          }
        }
    }

    func saveToDiskCache(_ gif:Gif){
    //manage strategys
        let diskCache = Guiso.get().getDiskCache()
        if mDiskCacheStrategy == .automatic {
            diskCache.addGif(mKey, images: gif.frames, delays: gif.delays,loopCount: gif.loopCount)
        }
    }

    func displayInTarget(_ img:UIImage){
        DispatchQueue.main.async {
            if self.mTarget?.getIdentifier() == self.mKey {
                self.mTarget?.onResourceReady(img)
            }
            self.mTarget = nil
        }
    }
    func displayInTarget(_ gif: GifDrawable){
       DispatchQueue.main.async {
        if self.mTarget?.getIdentifier() == self.mKey {
            let layer = GifLayer(gif)
                 self.mTarget?.onResourceReady(layer)
           }
           self.mTarget = nil
       }
    }
      
    func resizeImage(_ img: UIImage) -> UIImage? {
       switch mScaleType {
           case .fitCenter:
               return ImageHelper.fitCenter(image: img, width: mReqW, height: mReqH,lanczos: self.mLanczos)
           case .centerCrop:
               return ImageHelper.centerCrop(image: img, width: mReqW, height: mReqH,lanczos: self.mLanczos)
           default:
            return self.mLanczos ? ImageHelper.resizeVImage(img, mReqW, mReqH)
            : ImageHelper.resizeImage(img, targetWidth: mReqW, targetHeight: mReqH)
       }
    }
       
     
    private func makeImageData(_ img:UIImage, format: String) -> Data? {
       switch format {
           case "PNG","png":
               return img.pngData()
           default:
              return img.jpegData(compressionQuality: 1)
           }
    }
    
    
   
     
       
    func updateImageFromCache() -> Bool {
        let cache = Guiso.get().getMemoryCache()
        let cacheGif = Guiso.get().getMemoryCacheGif()
        let diskCache = Guiso.get().getDiskCache()
        
        if mMediaType == .gif {
             if let gifDrawable =  cacheGif.get(mKey) {
                    displayInTarget(gifDrawable)
                     return true
            }
            if let data = diskCache.get(mKey) {
                if let gif = ImageHelper.makeGif(data){
                     let drawable = ImageHelper.getGifDrawable(gif)
                    displayInTarget(drawable)
                    if mMemoryCache { cacheGif.add(mKey, val: drawable,isUpdate: false) }
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
                    if mMemoryCache { cache.add(mKey, val: img, isUpdate: false) }
                    return true
                }
            }

        }

        return false
    }
    
    func checkIfNeedIgnore() -> Bool {
        return getIdentifier() == mKey
    }
    
    func makeKey(_ override: Bool) -> Key {
       let key = override ? Key(signature: mUrl, width: mReqW, height: mReqH, scaleType: mScaleType, type:mMediaType) :
       Key(signature: mUrl, width: -1, height: -1, scaleType: .none , type: mMediaType)
        return key
       }
    
    func onLoadFailed(){
        DispatchQueue.main.async {
            self.mTarget?.onLoadFailed()
        }
    }
    
    
    func getAsset(identifier: String) -> PHAsset? {
        let assets = Guiso.get().getAssets()
        var a: PHAsset?
            
        for i in 0...(assets.count-1){
            let ph = assets[i]
            if ph.localIdentifier == identifier {
               a = ph
               break
            }
        }
        
        return a
        
    }
    
    func getPHContentMode(_ scaleType: Guiso.ScaleType)-> PHImageContentMode{
        switch scaleType {
        case .fitCenter:
           return .aspectFit
        case .centerCrop:
            return .aspectFill
        default:
            return .default
        }
    }
}
