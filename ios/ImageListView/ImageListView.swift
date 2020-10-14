//
//  ImageListView.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 10/9/20.
//

import UIKit


@objc(ImageListView)
class ImageListView: RCTViewManager {

    
    override func view() -> ImageList? {
      
        return ImageList()
     }
    override static func requiresMainQueueSetup() -> Bool {
      return true
    }
    
 
    @objc func getSelectedItems(_ tag:NSNumber, resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock){
         self.bridge.uiManager?.addUIBlock { (_, views) in
            if let v = views?[tag] as? ImageList{
                var items = [[String:Any?]]()
                v.mMediaCollection.getItems().forEach { (i) in
                    if(i?["isSelected"] as? Bool == true){
                        items.append(i!)
                    }
                }
               
                resolve(items)
            }else{
                rejecter("ImageList", "method getSelectedItems not found view", nil)
            }
        }
      
    }
    
    @objc func addItems(_ tag:NSNumber,items:[[String:Any]]){
        self.bridge.uiManager?.addUIBlock { (_, views) in
           if let v = views?[tag] as? ImageList{
               
            v.mMediaCollection.addItems(items)
            
           }
        }
    }
    
    
}
