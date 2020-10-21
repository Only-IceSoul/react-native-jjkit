//
//  Image.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

import Foundation
import UIKit


@objc(Image)
class Image: RCTViewManager {

    override func view() -> UIView! {
    
       return ImageView()
     }
    override static func requiresMainQueueSetup() -> Bool {
      return true
    }
    
    @objc func requestImageByTag(_ tag:NSNumber,format:String,quality:CGFloat, resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock){
      
         self.bridge?.uiManager?.addUIBlock { (_, views) in
            if let v = views?[tag] as? ImageView{
                
                if let re = format == "png" ? v.image?.pngData() : v.image?.jpegData(compressionQuality: quality){
                    resolve(re.base64EncodedString())
                    
                }else{
                    rejecter("Image", "failed to compress with Format \(format)", nil)
                }
               
               
            }else{
                rejecter("Image", "getImageByTag not found view", nil)
            }
        }
      
    }
    
    
}
