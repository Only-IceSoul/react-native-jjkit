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
          builder.getOptions().getPlaceHolder()?.setTarget(target)
          builder.getOptions().getPlaceHolder()?.load()
         
        let tracker = target
        tracker.getRequest()?.cancel()
        if let model = builder.getModel() {
            let request = GuisoRequest(model:model,options: builder.getOptions(),target,loader:builder.getLoader(),gifDecoder: builder.getGifDecoder())
            let p = getPriority( builder.getOptions().getPriority())
            tracker.setRequest(request)
            
            if let t = builder.getOptions().getThumbnail() , builder.getOptions().getThumbnail()?.getModel() != nil {
                print("adding thumb")
                let thumb = GuisoRequestThumb(model: t.getModel()!, options: t.getOptions(), target, loader: t.getLoader(), gifDecoder: t.getGifDecoder())
                request.setThumb(thumb)
                Guiso.get().getExecutor().doWork(thumb,priority: p , flags: .enforceQoS )
            }

            Guiso.get().getExecutor().doWork(request,priority: p , flags: .enforceQoS )
          
        }else{
            builder.getOptions().getFallbackHolder()?.setTarget(target)
            builder.getOptions().getFallbackHolder()?.load()
        }
          return tracker
      }
      

    static func preload(_ model:Any?,loader:LoaderProtocol,gifd: GifDecoderProtocol,options: GuisoOptions) -> Bool{
        if model != nil {
            let work = GuisoPreload(model: model!, options: options, loader: loader, gifDecoder: gifd)
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