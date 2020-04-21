//
//  ImageView.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

import UIKit

@objc(ImageView)
class ImageView: UIImageView {
    
     init(){
       super.init(frame:.zero)
       clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setScaleType(_ scaleType:Int){
        switch scaleType {
        case 1:
            contentMode = .scaleAspectFit
        default:
            contentMode = .scaleAspectFill
        }
    }
    
    var mCurrentUrl = ""
    @objc func setData(_ data:[String:Any]?){
        if data != nil {
            let w = data!["width"] as? Int ?? -1
            let h = data!["height"] as? Int ?? -1
            let cache = data!["cache"] as? Bool ?? false
            
            if let url = data!["url"] as? String , let type = data!["type"] as? String{
                self.mCurrentUrl = url
                if url.contains("http"){
                    self.updateImageWeb(url, cache,type, w, h)
                }else {
                   
                    self.updateImageFile(url, cache,type, w, h)
                }
            }
        }
    }
    
    private func updateImageWeb(_ url:String,_ cache:Bool,_ type:String,_ w:Int,_ h:Int){
        mReqW = w > 20 ? w : 20
        mReqH = h > 20 ? h : 20
        mUrlCache = w == -1 || h == -1 ? url : url+"\(mReqW)x\(mReqH)"
        mIsRequest =  w != -1 && h != -1
        mCaching = cache
        mUrl = url
        mType = type
        Thread(target: self, selector: #selector(makeUpdateImageWeb), object: nil).start()
    }
    
    @objc func makeUpdateImageWeb(){
        if mCaching {
          
        }else {
          
        }
        Thread.exit()
    }
    
    private var mReqW : Int = 0
    private var mReqH : Int = 0
    private var mUrlCache : String = ""
    private var mIsRequest = false
    private var mCaching = false
    private var mUrl : String = ""
    private var mType : String = ""
    private func updateImageFile(_ url:String,_ cache:Bool,_ type:String,_ w:Int,_ h:Int){
         mReqW = w > 20 ? w : 20
         mReqH = h > 20 ? h : 20
         mUrlCache = w == -1 || h == -1 ? url : url+"\(mReqW)x\(mReqH)"
         mIsRequest =  w != -1 && h != -1
         mCaching = cache
         mUrl = url
         mType = type
        Thread(target: self, selector: #selector(makeUpdateImageFile), object: nil).start()
    }
    
    @objc func makeUpdateImageFile(){
        if mCaching {
            if mIsRequest {
               self.updateImageCache(mUrl, mUrlCache,mType,mReqW,mReqH)
            }else {
               self.updateImageCache(mUrl, mUrlCache,mType)
            }
        }else {
            if mIsRequest {
              self.updateImageNoCache(mUrl,mType,mReqW,mReqH)
            }else {
              self.updateImageNoCache(mUrl,mType)
            }
        }
        Thread.exit()
    }
    
    
    
    private func updateImageCache(_ url:String,_ urlCache:String,_ type:String,_ w:Int,_ h:Int){
        if let img = mImageCache.get(urlCache) as? UIImage {
           DispatchQueue.main.async {
                 if(self.mCurrentUrl == url){
                     self.image = img
                }
            }
        }else{
            if type == "image" {
               PhotoKit.getImage(url,request: CGSize(width: w, height: h)) { (img) in
                       DispatchQueue.main.async {
                            if(self.mCurrentUrl == url){
                                self.image = img
                           }
                       }
                   if img != nil {
                       mImageCache.add(urlCache, val: img!)
                   }
               }
            }
            if type == "video"{
                PhotoKit.getVideoThumbnail(url, seconds: 1, request: CGSize(width: w, height: h)) { (img) in
                        DispatchQueue.main.async {
                               if(self.mCurrentUrl == url){
                                   self.image = img
                              }
                          }
                          if img != nil {
                              mImageCache.add(urlCache, val: img!)
                          }
                }
            }
        }

    }
    private func updateImageCache(_ url:String,_ urlCache:String,_ type:String){
            if let img = mImageCache.get(urlCache) as? UIImage {
                DispatchQueue.main.async {
                     if(self.mCurrentUrl == url){
                         self.image = img
                    }
                }
            }else{
                if type == "image"{
                    PhotoKit.getImage(url) { (img) in
                           DispatchQueue.main.async {
                                if(self.mCurrentUrl == url){
                                    self.image = img
                               }
                           }
                       if img != nil {
                           mImageCache.add(urlCache, val: img!)
                       }
                    }
                }
                if type == "video"{
                    PhotoKit.getVideoThumbnail(url, seconds: 1) { (img) in
                           DispatchQueue.main.async {
                                  if(self.mCurrentUrl == url){
                                      self.image = img
                                 }
                             }
                             if img != nil {
                                 mImageCache.add(urlCache, val: img!)
                             }
                     }
                }
            }
    }
    
    private func updateImageNoCache(_ url:String,_ type:String,_ w:Int,_ h:Int){
        if type == "image"{
            PhotoKit.getImage(url,request: CGSize(width: w, height: h)) { (img) in
                  DispatchQueue.main.async {
                       if(self.mCurrentUrl == url){
                           self.image = img
                      }
                  }
            }
        }
        if type == "video"{
            PhotoKit.getVideoThumbnail(url, seconds: 1, request: CGSize(width: w, height: h)) { (img) in
                   DispatchQueue.main.async {
                          if(self.mCurrentUrl == url){
                              self.image = img
                         }
                    }
           }
        }
    }
    private func updateImageNoCache(_ url:String,_ type:String){
        if type == "image" {
            PhotoKit.getImage(url) { (img) in
              DispatchQueue.main.async {
                   if(self.mCurrentUrl == url){
                       self.image = img
                  }
              }
            }
        }
        if type == "video"{
            PhotoKit.getVideoThumbnail(url, seconds: 1) { (img) in
                   DispatchQueue.main.async {
                          if(self.mCurrentUrl == url){
                              self.image = img
                         }
                    }
            }
        }
    }
}
