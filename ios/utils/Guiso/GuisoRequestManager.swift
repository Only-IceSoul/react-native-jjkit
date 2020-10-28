//
//  GuisoRequestManager.swift
//  Guiso
//
//  Created by Juan J LF on 5/21/20.
//

import Foundation

//should make a comunication betwen preload and request???????'
 class GuisoRequestManager {
    
    private static  var preloads = [String]()
    
   
    static func registryPreLoad(_ key:String){
        if key.isEmpty { return }
        preloads.append(key)
            
    }
    
    static func removePreload(_ key:String){
         if key.isEmpty { return }
        preloads.removeAll { (s) -> Bool in
            s == key
        }
    }

    static func containsPreload(_ key:String) -> Bool{
         if key.isEmpty { return false }
        return preloads.contains(key)
    }
    
    
    static func into(_ target: ViewTarget, builder:GuisoRequestBuilder) -> ViewTarget? {
        
    
        target.getRequest()?.cancel()
        target.onHolder(nil)
        
        builder.getOptions().getPlaceHolder()?.load(target)
         
        if builder.getModel() == nil {
            if let fb = builder.getOptions().getFallbackHolder() {
                fb.load(target)
            }else{
                builder.getOptions().getErrorHolder()?.load(target)
            }
           
            target.onLoadFailed("mainRequest: model is nil")
         }
      
       
        let mainRequest = GuisoRequest(model:builder.getModel(),builder.getPrimarySignature(),options: builder.getOptions(),target,loader:builder.getLoader(),animImgDecoder: builder.getAnimatedImageDecoder())
        
            let priority = getPriority( builder.getOptions().getPriority() )
           
            
            if let tb = builder.getOptions().getThumbnail() , builder.getOptions().getThumbnail()?.getModel() != nil {
                
                let thumbRequest = GuisoRequestThumb(model: tb.getModel()!,tb.getPrimarySignature(), options: tb.getOptions(), target, loader: tb.getLoader(), animImgDecoder: tb.getAnimatedImageDecoder())
                
                mainRequest.setThumb(thumbRequest)
                
                Guiso.get().getExecutor().doWork(thumbRequest,priority: priority , flags: .enforceQoS )
            }
        target.setRequest(mainRequest)
        if builder.getModel() != nil{
            Guiso.get().getExecutor().doWork(mainRequest,priority: priority , flags: .enforceQoS )
        }
           

          return target
    }
      

    static func preload(_ model:Any?,_ primarySignature:String,loader:LoaderProtocol,animtedImgDecoder: AnimatedImageDecoderProtocol,options: GuisoOptions) -> Bool{
        if model != nil {
            let work = GuisoPreload(model: model!,primarySignature, options: options, loader: loader, animImgDecoder: animtedImgDecoder)
            
            Guiso.get().getExecutor().doWork(work,priority: .background , flags: .enforceQoS )
            
            return true
        }
        return false
    }
      
    static func isPreloading(_ k:String) -> Bool {
          
          return GuisoRequestManager.containsPreload(k)
      }
    
    static func getPriority(_ priority:Guiso.Priority) -> DispatchQoS {
        switch priority {
        case .background:
          return .background
        case .high:
          return .userInteractive
        case .low:
          return .utility
        default:
          return .userInitiated
        }
    }
    
}
