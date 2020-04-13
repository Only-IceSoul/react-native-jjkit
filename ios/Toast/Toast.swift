//
//  JJToastModule.swift
//  JjToast
//
//  Created by Juan J LF on 4/3/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit

@objc(Toast)
class Toast : NSObject, RCTBridgeModule{
    
    static func moduleName() -> String {
        return "Toast"
    }
    
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc func show(_ message:String,lenght:Int){
        
        let d = lenght >= 1 || lenght < 0 ? ToastManager.Duration.LONG : ToastManager.Duration.SHORT

        DispatchQueue.main.async {
            ToastManager.makeText(message: message, duration: d)
        
        }
    }
    
    
 @objc func constantsToExport() -> [String: Any]! {
      return ["SHORT": 0,
              "LONG": 1]
    }
    
    

}
