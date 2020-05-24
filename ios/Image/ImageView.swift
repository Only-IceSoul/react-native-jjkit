//
//  ImageView.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

import UIKit

@objc(ImageView)
class ImageView: UIImageView , ViewTarget {
   
    
      
    
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
            let w = data!["width"] as? Int ?? -1
            let h = data!["height"] as? Int ?? -1
            let cache = data!["cache"] as? Bool ?? false
            let asGif = data!["asGif"] as? Bool ?? false
            
            if let url = data!["url"] as? String {
                let reqW = w > 20 ? w : 20
                let reqH = h > 20 ? w : 20
                
                updateImage(url, cache, asGif, w, h, reqW, reqH)
               
            }
        }
    }
    
    private func updateImage(_ url:String,_ cache:Bool,_ asGif:Bool,_ w:Int,_ h:Int,_ reqW:Int,_ reqH:Int){
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
    
    private func updateImageCache(_ url:String,_ asGif:Bool,_ w:Int,_ h:Int){
        if (asGif){
            if url.contains("base64,"){
                let s = url.split(separator: ",")[1]
                guard let data = Data(base64Encoded: String(s))
                    else {return}
                Guiso.load(model: data).asGif().fitCenter().override(w,h).into(self)
            }else {
                Guiso.load(model: url).asGif().fitCenter().override(w,h).into(self)
            }
        }else{
            if url.contains("base64,"){
                let s = url.split(separator: ",")[1]
                guard let data = Data(base64Encoded: String(s))
                    else {return}
                Guiso.load(model: data).frame(1)
                .fitCenter().override(w,h).into(self)
            }else {
                Guiso.load(model: url).frame(1)
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
                Guiso.load(model: data).asGif().into(self)
            }else {
                Guiso.load(model: url).asGif().into(self)
            }
          
        }else{
            if url.contains("base64,"){
               let s = url.split(separator: ",")[1]
               guard let data = Data(base64Encoded: String(s))
                   else {return}
                Guiso.load(model: data).frame(1).into(self)
            }else {
                Guiso.load(model: url).frame(1).into(self)
            }
            
        }
    }

    private func updateImageNoCache(_ url:String,_ asGif:Bool,_ w:Int,_ h:Int){
        if asGif {
            if url.contains("base64,"){
             let s = url.split(separator: ",")[1]
             guard let data = Data(base64Encoded: String(s))
                 else {return}
                Guiso.load(model: data).asGif()
                         .skipMemoryCache(true)
                         .fitCenter().override(w,h).into(self)
            }else {
                Guiso.load(model: url).asGif()
                        .skipMemoryCache(true)
                        .fitCenter().override(w,h).into(self)
            }
          
        }else{
            if url.contains("base64,"){
                let s = url.split(separator: ",")[1]
                guard let data = Data(base64Encoded: String(s))
                    else {return}
                Guiso.load(model: data).frame(1)
                    .skipMemoryCache(true)
                    .fitCenter().override(w,h).into(self)
            }else {
                Guiso.load(model: url).frame(1)
               .skipMemoryCache(true)
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
                Guiso.load(model: data).asGif()
                            .skipMemoryCache(true)
                            .into(self)
            }else {
                Guiso.load(model: url).asGif()
                       .skipMemoryCache(true)
                       .into(self)
            }
         
        }else{
            
            if url.contains("base64,"){
             let s = url.split(separator: ",")[1]
             guard let data = Data(base64Encoded: String(s))
                 else {return}
                Guiso.load(model: data).frame(1)
                   .skipMemoryCache(true)
                   .into(self)
            }else {
                Guiso.load(model: url).frame(1)
              .skipMemoryCache(true)
              .into(self)
            }
            
        }
    }

    init(){
           super.init(frame: .zero)
           clipsToBounds = true
          contentMode = .scaleAspectFill
       }
       
       public override init(frame: CGRect) {
           super.init(frame: frame)
           clipsToBounds = true
          contentMode = .scaleAspectFill
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           clipsToBounds = true
          contentMode = .scaleAspectFill
       }
       
       
       public func onFallback() {
         
       }
       
       //error, placeholder, fallback
       public func onHolder(_ image: UIImage?) {
           self.image = image
       }
    
       
       private var mGif: GifLayer?
       override public var bounds: CGRect{
           didSet{
               mGif?.onBoundsChange(bounds)
           }
       }
       
       public func onResourceReady(_ gif: GifLayer) {
           image = nil
           removeGif()
           addGif(gif)
       }
       
       public func onResourceReady(_ img: UIImage) {
           removeGif()
           image = img
       }
       
       public func onThumbReady(_ img: UIImage?) {
           //if thumb fail and error thumb fail  img is nil.
               removeGif()
               image = img
           
       }
       
       public func onThumbReady(_ gif: GifLayer) {
           image = nil
           removeGif()
           addGif(gif)
          
       }
       
       public func onLoadFailed() {
           // auto retry?
           //show clickview and let user retry?
           print("Load failed")
       }
     
       
       private var mRequest: GuisoRequest?
       public func setRequest(_ tag:GuisoRequest?) {
           mRequest = tag
       }
       public func getRequest() -> GuisoRequest?{
           return mRequest
       }
      

       public func getContentMode() -> UIView.ContentMode {
           return self.contentMode
       }
       
       override public func layoutSubviews() {
           super.layoutSubviews()
           if bounds.width > 0 && bounds.height > 0 && mGif?.isAnimating() == false {
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   self.mGif?.startAnimation()
               }
           }
       }
       
       private func removeGif(){
           mGif?.removeFromSuperlayer()
           mGif = nil
       }
       
       private func addGif(_ gif:GifLayer){
           mGif = gif
           mGif?.setContentMode(self.contentMode)
           layer.addSublayer(mGif!)
           mGif?.onBoundsChange(bounds)
       }

    
   
       
}
