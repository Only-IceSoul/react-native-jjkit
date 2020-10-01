//
//  GuisoTransformProtocol.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit


public protocol TransformProtocol {
    func transformGif(cg:CGImage,outWidth:CGFloat,outHeight:CGFloat) -> CGImage?
    func transformImage(img:UIImage,outWidth:CGFloat,outHeight:CGFloat) -> UIImage?
}

