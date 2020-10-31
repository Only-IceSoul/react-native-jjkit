//
//  GuisoRequestManager.swift
//  Guiso
//
//  Created by Juan J LF on 5/21/20.
//

import Foundation

//should make a comunication betwen preload and request???????'
 class GuisoRequestManager {
    
    private static  var preloads = [Key]()
    
   
    static func registryPreLoad(_ key:Key){
        if !key.isValidSignature() { return }
        preloads.append(key)
            
    }
    
    static func removePreload(_ key:Key){
        if !key.isValidSignature() { return }
        preloads.removeAll { (s) -> Bool in
            s == key
        }
    }

    static func containsPreload(_ key:Key) -> Bool{
        if !key.isValidSignature() { return false }
        return preloads.contains(key)
    }
    
    
    static func into(_ target: ViewTarget, builder:GuisoRequestBuilder) -> ViewTarget? {
        
        let request = GuisoRequest(model:builder.getModel(),builder.getPrimarySignature(),options: builder.getOptions(),target,loader:builder.getLoader(),animImgDecoder: builder.getAnimatedImageDecoder())
        
        if let tb = builder.getThumb() , builder.getThumb()?.getModel() != nil {
            
            let thumbRequest = GuisoRequestThumb(model: tb.getModel()!,tb.getPrimarySignature(), options: tb.getOptions(), target, loader: tb.getLoader(), animImgDecoder: tb.getAnimatedImageDecoder())
            
            request.setThumb(thumbRequest)
            
        }
    
        if let previous = target.getRequest() {
            if previous == request && !(builder.getOptions().getSkipMemoryCache() && previous.isComplete()) {
                
                if !previous.isRunning(){
                    previous.isCancelled = false
                    previous.begin()
                }
                
                return target
            }
        }
        
     
        clear(target: target)
        target.setRequest(request)
        request.begin()
        
          return target
    }
      
    static func clear(target:ViewTarget){
        target.getRequest()?.setTarget(nil)
        target.getRequest()?.clear()
        target.setRequest(nil)
    }

  
      
    static func isPreloading(_ k:Key) -> Bool {
          
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
