//
//  SimpleTarget.swift
//  Guiso
//
//  Created by Juan J LF on 5/23/20.
//

import UIKit

public protocol SimpleTarget {
    
    func onLoadStarted()
    func onResourceReady(_ gif:AnimatedLayer)
    func onResourceReady(_ img:UIImage)
    func onLoadFailed()
    func isComplete()
    

}
