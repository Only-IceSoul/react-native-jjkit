//
//  GuisoImage.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit


protocol ViewTarget {
    
    func setIdentifier(_ tag:String)
    func getIdentifier() -> String
    func onResourceReady(_ gif:GifLayer)
    func onResourceReady(_ img:UIImage)
    func onLoadFailed()
    func getContentMode() -> UIView.ContentMode

}
