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
    
    
}
