//
//  CircleProgressView.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/5/20.
//


import Foundation

@objc(CircleProgressView)
class CircleProgressView: RCTViewManager {

    override func view() -> UIView! {
    
       return CircleProgress()
     }
      
    override static func requiresMainQueueSetup() -> Bool {
      return true
    }
 
    
}
