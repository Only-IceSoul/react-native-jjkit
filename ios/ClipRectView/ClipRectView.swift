//
//  ClipRectView.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/5/20.
//

import Foundation
import UIKit

@objc(ClipRectView)
class ClipRectView: RCTViewManager {

    override func view() -> UIView! {
    
       return ClipRect()
     }
      
    override static func requiresMainQueueSetup() -> Bool {
      return true
    }
 
    
}
