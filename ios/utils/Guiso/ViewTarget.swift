//
//  GuisoImage.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit


public protocol ViewTarget {
    
    func setRequest(_ tag:GuisoRequest?)
    func getRequest() -> GuisoRequest?
    func onResourceReady(_ gif:GifLayer)
    func onResourceReady(_ img:UIImage)
    func onThumbReady(_ img: UIImage?)
    func onThumbReady(_ gif: GifLayer)
    func onLoadFailed(_ error:String)
    func getContentMode() -> UIView.ContentMode
    func onHolder(_ image:UIImage?)
    func onFallback()

}
