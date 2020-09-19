//
//  ImageView.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

import UIKit

@objc(ImageView)
class ImageView: UIImageView , ViewTarget {
   
    
    @objc var onLoadStart : RCTDirectEventBlock?
    @objc var onLoadError : RCTDirectEventBlock?
    @objc var onLoadSuccess : RCTDirectEventBlock?
    @objc var onLoadEnd : RCTDirectEventBlock?
    
    @objc func setScaleType(_ scaleType:Int){
        switch scaleType {
        case 1:
            contentMode = .scaleAspectFit
        default:
            contentMode = .scaleAspectFill
        }
    }
    
 
    
    @objc func setSource(_ data:[String:Any]?){

        if data != nil {
            let w = data!["width"] as? Int ?? -1
            let h = data!["height"] as? Int ?? -1
            let cache = data!["cache"] as? Bool ?? false
            let asGif = data!["asGif"] as? Bool ?? false
            let placeholder = data!["placeholder"] as? String
            
            if let url = data!["uri"] as? String {
                let resize = w != 1 && h != -1
                let reqW = w > 20 ? w : 20
                let reqH = h > 20 ? h : 20
                
                updateImage(url,placeholder, cache, asGif, resize, reqW, reqH)
               
            }
        }
    }
    
    private func updateImage(_ url:String,_ placeholder:String?,_ cache:Bool,_ asGif:Bool,_ resize:Bool,_ reqW:Int,_ reqH:Int){
        
        Guiso.get().getExecutor().doWork {
            let options = self.getOptions(asGif: asGif, cache: cache, placeholder: placeholder, resize: resize, reqW: reqW, reqH: reqH)
                
                var manager = Guiso.load(model: "")
                
                if url.contains("base64,"){
                    let s = url.split(separator: ",")[1]
                     let data = Data(base64Encoded: String(s))
                     
                    manager = Guiso.load(model: data)
                
                }else if url.contains("static;"){
                    let s = url.split(separator: ";")[1]
                    let ss = String(s)
                    manager = Guiso.load(model:  URL(string: ss))
                
                }else {
                     manager = Guiso.load(model: url)
                }
                
            
                DispatchQueue.main.async {
                    self.onLoadStart?([String:Any]())
                          manager.apply(options)
                          .into(self)
                }
            
        }
        
        
      
           
    }
    
    private func getOptions(asGif:Bool,cache:Bool,
                            placeholder:String?,resize:Bool,reqW:Int,reqH:Int) -> GuisoOptions {
        var options = GuisoOptions().skipMemoryCache(cache)
        
        if let ph = load(model: placeholder){
            options = options.placeHolder(ph)
        }
        
        if(!asGif){
            options = options.frame(1)
        }else{
            options = options.asGif()
        }
        
        if(resize){
            options = options.fitCenter().override(reqW,reqH)
        }
        
        return options
        
    }
    
    
    private func load(model:String?) -> UIImage?{
        var result: UIImage? = nil
        if(model != nil){
   
            if(model!.contains("base64,")){
                let s = model!.split(separator: ",")[1]
                let ss = String(s)
               if let d = Data(base64Encoded: ss){
                 result = UIImage(data: d)
                }
            }
            
            if(model!.contains("static;")){
                let s = model!.split(separator: ";")[1]
                let ss = String(s)
                if let url = URL(string: ss), let data = try? Data(contentsOf: url){
                    result = UIImage(data: data)
                }
            }
        }
        
        return result
        
    }
    
    
 
    init(){
           super.init(frame: .zero)
           clipsToBounds = true
          contentMode = .scaleAspectFit
       }
       
       public override init(frame: CGRect) {
           super.init(frame: frame)
           clipsToBounds = true
          contentMode = .scaleAspectFit
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           clipsToBounds = true
          contentMode = .scaleAspectFit
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
        onLoadSuccess?(["width": gif.pixelWidth,
                            "height": gif.pixelHeight])
        onLoadEnd?([String:Any]())
       }
       
       public func onResourceReady(_ img: UIImage) {
           removeGif()
           image = img
        onLoadSuccess?(["width": img.cgImage?.width ?? 0 ,
                         "height": img.cgImage?.height ?? 0])
        onLoadEnd?([String:Any]())
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
          onLoadError?(["error":""])
          onLoadEnd?([String:Any]())
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
