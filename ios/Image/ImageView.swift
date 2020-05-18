//
//  ImageView.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

import UIKit

@objc(ImageView)
class ImageView: UIImageView , ViewTarget {
   
    
     init(){
       super.init(frame:.zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
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
    
    @objc func setData(_ data:[String:Any]?){

        if data != nil {
            let w = data!["width"] as? CGFloat ?? -1
            let h = data!["height"] as? CGFloat ?? -1
            let cache = data!["cache"] as? Bool ?? false
            let asGif = data!["asGif"] as? Bool ?? false
            
            if let url = data!["url"] as? String {
                let reqW = w > 20 ? w : 20
                let reqH = h > 20 ? w : 20
                
                updateImage(url, cache, asGif, w, h, reqW, reqH)
               
            }
        }
    }
    
    private func updateImage(_ url:String,_ cache:Bool,_ asGif:Bool,_ w:CGFloat,_ h:CGFloat,_ reqW:CGFloat,_ reqH:CGFloat){
            if (cache) {
                if (w != 1 && h != -1) {
                    updateImageCache(url,asGif,reqW,reqH)
                }else {
                    updateImageCache(url,asGif)
                }
            }else {
                if (w != 1 && h != -1)  {
                    updateImageNoCache(url,asGif,reqW,reqH)
                }else {
                    updateImageNoCache(url,asGif)
                }
            }
    }
    
    private func updateImageCache(_ url:String,_ asGif:Bool,_ w:CGFloat,_ h:CGFloat){
        if (asGif){
            if url.contains("base64,"){
                let s = url.split(separator: ",")[1]
                guard let data = Data(base64Encoded: String(s))
                    else {return}
                Guiso.load(data).asGif().fitCenter().override(w,h).into(self)
            }else {
               Guiso.load(url).asGif().fitCenter().override(w,h).into(self)
            }
        }else{
            if url.contains("base64,"){
                let s = url.split(separator: ",")[1]
                guard let data = Data(base64Encoded: String(s))
                    else {return}
                Guiso.load(data).frame(1)
                .fitCenter().override(w,h).into(self)
            }else {
              Guiso.load(url).frame(1)
               .fitCenter().override(w,h).into(self)
            }
           
        }
    }

    private func updateImageCache(_ url:String,_ asGif:Bool){
        if (asGif){
            if url.contains("base64,"){
               let s = url.split(separator: ",")[1]
               guard let data = Data(base64Encoded: String(s))
                   else {return}
                 Guiso.load(data).asGif().into(self)
            }else {
                Guiso.load(url).asGif().into(self)
            }
          
        }else{
            if url.contains("base64,"){
               let s = url.split(separator: ",")[1]
               guard let data = Data(base64Encoded: String(s))
                   else {return}
                 Guiso.load(data).frame(1).into(self)
            }else {
                Guiso.load(url).frame(1).into(self)
            }
            
        }
    }

    private func updateImageNoCache(_ url:String,_ asGif:Bool,_ w:CGFloat,_ h:CGFloat){
        if asGif {
            if url.contains("base64,"){
             let s = url.split(separator: ",")[1]
             guard let data = Data(base64Encoded: String(s))
                 else {return}
                 Guiso.load(data).asGif()
                         .skipMemoryCache()
                         .fitCenter().override(w,h).into(self)
            }else {
                Guiso.load(url).asGif()
                        .skipMemoryCache()
                        .fitCenter().override(w,h).into(self)
            }
          
        }else{
            if url.contains("base64,"){
                let s = url.split(separator: ",")[1]
                guard let data = Data(base64Encoded: String(s))
                    else {return}
                    Guiso.load(data).frame(1)
                    .skipMemoryCache()
                    .fitCenter().override(w,h).into(self)
            }else {
               Guiso.load(url).frame(1)
               .skipMemoryCache()
               .fitCenter().override(w,h).into(self)
            }
            
        }
    }
    
    private func updateImageNoCache(_ url:String,_ asGif:Bool){
        if asGif {
            if url.contains("base64,"){
               let s = url.split(separator: ",")[1]
               guard let data = Data(base64Encoded: String(s))
                   else {return}
                     Guiso.load(data).asGif()
                            .skipMemoryCache()
                            .into(self)
            }else {
                Guiso.load(url).asGif()
                       .skipMemoryCache()
                       .into(self)
            }
         
        }else{
            
            if url.contains("base64,"){
             let s = url.split(separator: ",")[1]
             guard let data = Data(base64Encoded: String(s))
                 else {return}
                   Guiso.load(data).frame(1)
                   .skipMemoryCache()
                   .into(self)
            }else {
             Guiso.load(url).frame(1)
              .skipMemoryCache()
              .into(self)
            }
            
        }
    }

    
    private var mGif: GifLayer?
        override var bounds: CGRect{
           didSet{
               mGif?.onBoundsChange(bounds)
           }
       }
       
       func onResourceReady(_ gif: GifLayer) {
           image = nil
           mGif?.removeFromSuperlayer()
           mGif = gif
           mGif?.setContentMode(self.contentMode)
           layer.addSublayer(mGif!)
           mGif?.onBoundsChange(bounds)
          
           
       }
       
       func onResourceReady(_ img: UIImage) {
           mGif?.removeFromSuperlayer()
           mGif = nil
           image = img
       }
       
       func onLoadFailed() {
           // image error
           print("Load failed Guiso")
       }
     
       
       private var mIdentifier = "error"
               
       func setIdentifier(_ tag:String) {
           mIdentifier = tag
       }
       func getIdentifier() -> String{
           return mIdentifier
       }

     func getContentMode() -> UIView.ContentMode {
        return self.contentMode
    }
       
       
       override func layoutSubviews() {
           super.layoutSubviews()
           if bounds.width > 0 && bounds.height > 0 && mGif?.isAnimating() == false {
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   self.mGif?.startAnimation()
               }
           }
       }
       
}
