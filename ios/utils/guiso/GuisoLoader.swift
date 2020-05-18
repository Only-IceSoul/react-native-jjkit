//
//  GuisoLoader.swift
//
//  Created by Juan J LF on 4/23/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//


import UIKit
import Photos


class GuisoLoader {
   private var mKey: String!
   private var mTarget : ViewTarget!
   private var mMemoryCache : Bool!
   private var mUrl : String!
   private var mDiskCacheStrategy : Guiso.DiskCacheStrategy!
   private var mReqW: CGFloat = 0
   private var mReqH: CGFloat = 0
   private var mSecond : Double = 0
   private var mScaleType: Guiso.ScaleType
   private var mMediaType : Guiso.MediaType!
   private var mExtension = "jpeg"
   private var mLanczos = false
   private var mExactFrame = false
   private var mData:Data?
   private var mSignature = ""
   private var mTargetContentMode: UIView.ContentMode = .scaleAspectFit
   init(_ request: GuisoRequestBuilder,_ target:ViewTarget) {
       mUrl = request.getUrl()
       mSignature = request.getSignature()
       mData = request.getData()
       mTarget = target
       mReqH = request.getHeight()
       mReqW = request.getWidth()
       mReqW = mReqW > 20 ? mReqW : 20
       mReqH = mReqH > 20 ? mReqH : 20
       mMemoryCache = !request.getSkipMemoryCache()
       mSecond = request.getFrameSecond()
       mScaleType = request.getScaleType()
       mMediaType = request.getMediaType()
       mExactFrame = request.getExactFrame()
       let key = makeKey(request.getIsOverride())
       mKey = key.toString()
       mExtension = key.getExtension()
       mDiskCacheStrategy = request.getDiskCacheStrategy()
       mLanczos = request.getLanczos()
  
       DispatchQueue.main.async{
           self.mTargetContentMode = self.mTarget.getContentMode()
       }
       
   }
   
   private func resetFrameAndExact(){
       mExactFrame = false
       mSecond = 0
   }
   
   func updateIdentifier(){
       self.mTarget!.setIdentifier(mKey)
   }
   
   func getIdentifier() -> String {
       return self.mTarget!.getIdentifier()
   }
   
   func updateTargetDataResizeGif(){
       if mData != nil && mData?.isEmpty == false {
           if mScaleType == .none {
               mScaleType = mTargetContentMode == .scaleAspectFill  ? .centerCrop : .fitCenter
           }
           if let gif = ImageHelper.makeGif(mData!, self.mReqW, self.mReqH, self.mScaleType,lanczos: self.mLanczos){
              let drawable = ImageHelper.getGifDrawable(gif)
              self.displayInTarget(drawable)
              if self.mMemoryCache { self.saveToMemoryCache(drawable) }
              self.saveToDiskCache(gif)
          } else { self.onLoadFailed() }

       }else { self.onLoadFailed() }
        
    }
   func updateTargetDataFullSizeGif(){
       if mData != nil && mData?.isEmpty == false {
           if let gif = ImageHelper.makeGif(mData!){
               let drawable = ImageHelper.getGifDrawable(gif)
               self.displayInTarget(drawable)
               if self.mMemoryCache { self.saveToMemoryCache(drawable) }
               self.saveToDiskCache(gif)
           }else { self.onLoadFailed() }
       }else { self.onLoadFailed() }
   }

   func updateTargetDataResize(){
       if mData != nil && mData?.isEmpty == false {
         if let fullSize = UIImage(data: mData!){
           if let resized = self.resizeImage(fullSize){
                 self.displayInTarget(resized)
                 if self.mMemoryCache { self.saveToMemoryCache(resized) }
                 self.saveToDiskCache(resized)
           }else { self.onLoadFailed() }
         }else{
             if let fs = ImageHelper.getVideoThumbnail(video: mData!, second: mSecond, exact: mExactFrame){
                   if let rsv = self.resizeImage(fs){
                      self.displayInTarget(rsv)
                      if self.mMemoryCache { self.saveToMemoryCache(rsv) }
                      self.saveToDiskCache(rsv)
                   }else { self.onLoadFailed() }
             }else{
                   guard let fsa =  ImageHelper.getAudioArtWork(mData!),
                       let rsa = self.resizeImage(fsa)
                       else { onLoadFailed()
                           return
                       }
                   self.displayInTarget(rsa)
                   if self.mMemoryCache { self.saveToMemoryCache(rsa) }
                   self.saveToDiskCache(rsa)
             }
         }

       }else { self.onLoadFailed() }
       
   }
   func updateTargetDataFullSize(){
       if mData != nil && mData?.isEmpty == false {
           if let fullSize = UIImage(data: mData!){
               self.displayInTarget(fullSize)
               if self.mMemoryCache { self.saveToMemoryCache(fullSize) }
               // self.saveToDiskCache(fullSize)
           }else{
               if let fs = ImageHelper.getVideoThumbnail(video: mData!, second: mSecond, exact: mExactFrame){
                   self.displayInTarget(fs)
                   if self.mMemoryCache { self.saveToMemoryCache(fs) }
                   // self.saveToDiskCache(fullSize)
               }else{
                  
                   guard let fsA =  ImageHelper.getAudioArtWork(mData!)
                   else { self.onLoadFailed()
                       return
                    }
                   
                    self.displayInTarget(fsA)
                   if self.mMemoryCache { self.saveToMemoryCache(fsA) }
                   //self.saveToDiskCache(fsA)
               }
           }
        
       }else { self.onLoadFailed() }
   }
   
   func updateTargetResize(){
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
           ImageHelper.getVideoThumbnail(asset, second: mSecond,exact: mExactFrame) { (fullSize, error) in
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
           ImageHelper.getVideoThumbnail(asset, second: mSecond,exact: mExactFrame) { (fullSize, error) in
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
           ImageHelper.getDataFileManager(asset: asset) { (data) in
               if data != nil {
                   if self.mScaleType == .none {
                       self.mScaleType = self.mTargetContentMode == .scaleAspectFill  ? .centerCrop : .fitCenter
                    }
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
           ImageHelper.getDataFileManager(asset: asset) { (data) in
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
               if self.mScaleType == .none {
                  self.mScaleType = self.mTargetContentMode == .scaleAspectFill  ? .centerCrop : .fitCenter
               }
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
               if let fullSize = UIImage(data: data!){
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
               if let fullSize = UIImage(data: data!){
                   self.displayInTarget(fullSize)
                   if self.mMemoryCache { self.saveToMemoryCache(fullSize) }
                   self.saveToDiskCache(fullSize)
               }else { self.onLoadFailed() }
           }else { self.onLoadFailed() }
       }.resume()
   }
  
   func updateTargetResizeWebVideo(){
       guard let url = URL(string: mUrl),
           let fullSize =  ImageHelper.getVideoThumbnail(videoUrl: url, second: mSecond,exact: mExactFrame),
           let resized = self.resizeImage(fullSize)
           else { onLoadFailed()
               return
           }

       self.displayInTarget(resized)
       if self.mMemoryCache { self.saveToMemoryCache(resized) }
       self.saveToDiskCache(resized)
   }
   func updateTargetFullSizeWebVideo(){
       guard let url = URL(string: mUrl),
       let fullSize =  ImageHelper.getVideoThumbnail(videoUrl: url, second: mSecond,exact: mExactFrame)
       else { onLoadFailed()
           return
        }
       
        self.displayInTarget(fullSize)
       if self.mMemoryCache { self.saveToMemoryCache(fullSize) }
       self.saveToDiskCache(fullSize)
   }
   
   func updateTargetResizeWebAudio(){
       guard let url = URL(string: mUrl),
           let fullSize =  ImageHelper.getAudioArtWork(url),
           let resized = self.resizeImage(fullSize)
           else { onLoadFailed()
               return
           }

       self.displayInTarget(resized)
       if self.mMemoryCache { self.saveToMemoryCache(resized) }
       self.saveToDiskCache(resized)
   }
   
   func updateTargetFullSizeWebAudio(){
       guard let url = URL(string: mUrl),
        let fullSize =  ImageHelper.getAudioArtWork(url)
        else { onLoadFailed()
            return
         }
        
         self.displayInTarget(fullSize)
        if self.mMemoryCache { self.saveToMemoryCache(fullSize) }
        self.saveToDiskCache(fullSize)
   }
   
   func updateTargetResizeFile(){
       guard let url = URL(string: mUrl),
           let data = try? Data(contentsOf: url),
           let fullSize = UIImage(data: data),
           let resized = self.resizeImage(fullSize)
       else { onLoadFailed()
               return
       }
       self.displayInTarget(resized)
      if self.mMemoryCache { self.saveToMemoryCache(resized) }
      self.saveToDiskCache(resized)
   }
   func updateTargetFullSizeFile(){
       guard let url = URL(string: mUrl),
             let data = try? Data(contentsOf: url),
             let fullSize = UIImage(data: data)
         else { onLoadFailed()
                 return
         }
         self.displayInTarget(fullSize)
        if self.mMemoryCache { self.saveToMemoryCache(fullSize) }
        //self.saveToDiskCache(fullSize)
   }
   func updateTargetResizeFileVideo(){
       guard let url = URL(string: mUrl),
           let fullSize = ImageHelper.getVideoThumbnail(videoUrl: url, second: mSecond,exact: mExactFrame),
           let resized = self.resizeImage(fullSize)
        else { self.onLoadFailed()
                   return
            }
       self.displayInTarget(resized)
       if self.mMemoryCache { self.saveToMemoryCache(resized) }
       self.saveToDiskCache(resized)
   }
   func updateTargetFullSizeFileVideo(){
       guard let url = URL(string: mUrl),
          let fullSize = ImageHelper.getVideoThumbnail(videoUrl: url, second: mSecond,exact: mExactFrame)
       else { self.onLoadFailed()
                  return
           }
      self.displayInTarget(fullSize)
      if self.mMemoryCache { self.saveToMemoryCache(fullSize) }
      // self.saveToDiskCache(fullSize)
   }

   func updateTargetResizeFileAudio(){
       guard let url = URL(string: mUrl),
            let fullSize = ImageHelper.getAudioArtWork(url),
           let resized = self.resizeImage(fullSize)
         else { self.onLoadFailed()
                    return
             }
        self.displayInTarget(resized)
        if self.mMemoryCache { self.saveToMemoryCache(resized) }
        self.saveToDiskCache(resized)
   }
   func updateTargetFullSizeFileAudio(){
       guard let url = URL(string: mUrl),
           let fullSize = ImageHelper.getAudioArtWork(url)
       else { self.onLoadFailed()
              return
       }
       self.displayInTarget(fullSize)
       if self.mMemoryCache { self.saveToMemoryCache(fullSize) }
      // self.saveToDiskCache(fullSize)
   }
   
   func updateTargetResizeFileGif(){
       if self.mScaleType == .none {
          self.mScaleType = self.mTargetContentMode == .scaleAspectFill  ? .centerCrop : .fitCenter
       }
       guard let url = URL(string: mUrl),
         let data = try? Data(contentsOf: url),
           let gif = ImageHelper.makeGif(data, mReqW, mReqH, mScaleType,lanczos: self.mLanczos)
       else { self.onLoadFailed()
            return
       }
        let gifDrawable = ImageHelper.getGifDrawable(gif)
       self.displayInTarget(gifDrawable)
       if self.mMemoryCache { self.saveToMemoryCache(gifDrawable) }
       self.saveToDiskCache(gif)
   }
   func updateTargetFullSizeFileGif(){
       guard let url = URL(string: mUrl),
           let data = try? Data(contentsOf: url),
           let gif = ImageHelper.makeGif(data)
       else { self.onLoadFailed()
           return
       }
       let gifDrawable = ImageHelper.getGifDrawable(gif)
       self.displayInTarget(gifDrawable)
       if self.mMemoryCache { self.saveToMemoryCache(gifDrawable) }
       //self.saveToDiskCache(gif)
   }
   
   
   func saveToMemoryCache(_ img:UIImage?){
       if img == nil || mSignature.isEmpty { return  }
        let cache = Guiso.get().getMemoryCache()
        cache.add(mKey, val: img!)
   }
   
   func saveToMemoryCache(_ gif:GifDrawable?){
      if gif == nil || mSignature.isEmpty  { return  }
      let cache = Guiso.get().getMemoryCacheGif()
       cache.add(mKey, val: gif!)
   }
   
   func saveToDiskCache(_ image:UIImage){
       if  mSignature.isEmpty  { return  }
       //manage strategys
       let diskCache = Guiso.get().getDiskCache()
       if mDiskCacheStrategy == .automatic {
         if let data = makeImageData(image, format: mExtension){
               diskCache.add(mKey, data: data)
         }
       }
   }

   func saveToDiskCache(_ gif:Gif){
       if  mSignature.isEmpty  { return  }
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
           return (mTargetContentMode == .scaleAspectFill) ? ImageHelper.centerCrop(image: img, width: mReqW, height: mReqH,lanczos: self.mLanczos)
           : ImageHelper.fitCenter(image: img, width: mReqW, height: mReqH,lanczos: self.mLanczos)
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
       let scaleType = mScaleType == .none ? getScaleTypeFrom(mTargetContentMode) : mScaleType
       let key = override ? Key(signature: mSignature, width: mReqW, height: mReqH, scaleType: scaleType, frame: mSecond,exactFrame:mExactFrame, type:mMediaType) :
           Key(signature: mSignature, width: -1, height: -1, scaleType: .none,frame: mSecond ,exactFrame:mExactFrame, type: mMediaType)
       return key
      }
   
   private func getScaleTypeFrom(_ scale:UIView.ContentMode)-> Guiso.ScaleType{
         return scale == UIView.ContentMode.scaleAspectFill ? .centerCrop : .fitCenter
     }
     
   
   func onLoadFailed(){
       DispatchQueue.main.async {
           self.mTarget?.setIdentifier("error")
           self.mTarget?.onLoadFailed()
       }
   }
   
   private func getSignatureData() -> String{
       return  ""
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
