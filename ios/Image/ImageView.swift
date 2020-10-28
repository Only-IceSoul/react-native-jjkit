//
//  ImageView.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

import UIKit

@objc(ImageView)
class ImageView: UIImageView , ViewTarget {
    
    private let RESIZE_MODE_CONTAIN = "contain"
    private let RESIZE_MODE_COVER = "cover"
    private let SCALE_TYPE_CONTAIN = "contain"
    private let SCALE_TYPE_COVER = "cover"
    private let PRIORITY_LOW = "low"
    private let PRIORITY_NORMAL = "normal"
    private let PRIORITY_HIGH = "high"
    private let DISK_CACHE_STRATEGY_ALL = "all"
    private let DISK_CACHE_STRATEGY_NONE = "none"
    private let DISK_CACHE_STRATEGY_AUTOMATIC = "automatic"
    private let DISK_CACHE_STRATEGY_DATA = "data"
    private let DISK_CACHE_STRATEGY_RESOURCE = "resource"
   
    
    @objc var onLoadStart : RCTDirectEventBlock?
    @objc var onLoadError : RCTDirectEventBlock?
    @objc var onLoadSuccess : RCTDirectEventBlock?
    @objc var onLoadEnd : RCTDirectEventBlock?
    
    @objc func setScaleType(_ scaleType:String){
        switch scaleType {
        case SCALE_TYPE_COVER:
            contentMode = .scaleAspectFill
        default:
            contentMode = .scaleAspectFit
        }
    }
    
 
    
    @objc func setSource(_ data:[String:Any]?){

        if data != nil {
            let w = data!["width"] as? Int ?? -1
            let h = data!["height"] as? Int ?? -1
            let mode = data!["resizeMode"] as? String  ?? RESIZE_MODE_CONTAIN
            let skipMemoryCache = data!["skipMemoryCache"] as? Bool ?? false
            let diskCacheStrategy = data!["diskCacheStrategy"] as? String ?? DISK_CACHE_STRATEGY_AUTOMATIC
            let asGif = data!["asGif"] as? Bool ?? false
            let placeholder = data!["placeholder"] as? String
            let headers = data!["headers"] as? [String:String]
            let prio = data!["priority"] as? String ?? PRIORITY_NORMAL
            let uri = data!["uri"] as? String
    
            let priority :Guiso.Priority = prio == PRIORITY_LOW ? .low : prio == PRIORITY_HIGH ? .high: .normal
            
            let resize = w != 1 && h != -1
            let reqW = w > 20 ? w : 20
            let reqH = h > 20 ? h : 20
            
            updateImage(uri,placeholder,headers,priority, skipMemoryCache,diskCacheStrategy, asGif, resize, reqW, reqH,mode)
           
            
        }
    }
    
    private func updateImage(_ url:String?,_ placeholder:String?,_ headers:[String:String]?,_ priority:Guiso.Priority,_ cache:Bool,_ diskCacheStrategy: String,_ asGif:Bool,_ resize:Bool,_ reqW:Int,_ reqH:Int,_ resizeMode:String){
        
        Guiso.get().getExecutor().doWork {
            let options = self.getOptions(asGif: asGif,headers:headers, cache: cache,diskCacheStrategy, placeholder: placeholder,priority: priority, resize: resize, reqW: reqW, reqH: reqH,resizeMode)
                
                var manager = Guiso.load(model: "")
                
                if url?.contains("base64,") == true{
                    let s = url!.split(separator: ",")[1]
                     let data = Data(base64Encoded: String(s))
                     
                    manager = Guiso.load(model: data)
                
                }else if url?.contains("static;") == true{
                    let s = url!.split(separator: ";")[1]
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
    
    private func getOptions(asGif:Bool,headers: [String:String]?,cache:Bool,
                            _ diskCacheStrategy:String,
                            placeholder:String?,priority:Guiso.Priority,resize:Bool,reqW:Int,reqH:Int,_ mode:String) -> GuisoOptions {
        
        let ds: Guiso.DiskCacheStrategy = getDiskCacheStrategy(diskCacheStrategy)
        
        var options = GuisoOptions().skipMemoryCache(cache)
            .priority(priority)
            .diskCacheStrategy(ds)
         
        if headers != nil {
            options = options.header(GuisoHeader(headers!))
        }
        
        if let ph = load(model: placeholder){
            options = options.placeHolder(ph)
        }
        
        if(!asGif){
            options = options.frame(1)
        }else{
            options = options.asAnimatedImage(.gif)
        }
        
        if(resize){
            options = mode == RESIZE_MODE_COVER ? options.centerCrop().override(reqW,reqH)
                : options.fitCenter().override(reqW,reqH)
        }
        
        return options
        
    }
    
    
    private func getDiskCacheStrategy(_ strategy:String) -> Guiso.DiskCacheStrategy{
        var s:Guiso.DiskCacheStrategy = .automatic
        switch strategy {
        case DISK_CACHE_STRATEGY_NONE:
            s = .none
        case DISK_CACHE_STRATEGY_ALL:
            s = .all
        case DISK_CACHE_STRATEGY_DATA:
            s = .data
        case DISK_CACHE_STRATEGY_RESOURCE:
            s = .resource
        default:
            s = .automatic
        }
        
        return s
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
           removeGif()
           self.image = image
       }
    
       
       private var mGif: AnimatedLayer?
       override public var bounds: CGRect{
           didSet{
               mGif?.onBoundsChange(bounds)
           }
       }
       
       public func onResourceReady(_ gif: AnimatedLayer) {
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
       
       public func onThumbReady(_ gif: AnimatedLayer) {
           image = nil
           removeGif()
           addGif(gif)
          
       }
       
    public func onLoadFailed(_ error:String) {
           // auto retry?
           //show clickview and let user retry?
          onLoadError?(["error":error])
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
       
       private func addGif(_ gif:AnimatedLayer){
           mGif = gif
           mGif?.setContentMode(self.contentMode)
           layer.addSublayer(mGif!)
           mGif?.onBoundsChange(bounds)
       }

    
   
       
}
