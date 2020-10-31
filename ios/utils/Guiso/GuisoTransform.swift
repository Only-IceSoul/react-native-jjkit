//
//  GuisoTransform.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit


class GuisoTransform {
    
  
    

    static func transformGif(cg: CGImage, outWidth: CGFloat, outHeight: CGFloat,scale:Guiso.ScaleType,l: Bool) -> CGImage? {
        
        let resized = outWidth != -1 && outHeight != -1
        return resized ? makeTransform(cg:cg,w:outWidth,h:outHeight,scale: scale,l:l) : cg
        
    }
    
    static func transformImage(img: UIImage, outWidth: CGFloat, outHeight: CGFloat,scale:Guiso.ScaleType,l: Bool) -> UIImage? {
        let resized = outWidth != -1 && outHeight != -1
        return resized ? makeTransform(img:img,w:outWidth,h:outHeight,scale: scale,l:l) : img
    }
    
    
    private static func makeTransform(cg:CGImage,w: CGFloat,h:CGFloat,scale:Guiso.ScaleType,l: Bool) -> CGImage? {
        return scale == .centerCrop ? TransformationUtils.centerCrop(cgImage: cg, width: w, height: h,lanczos:l) : TransformationUtils.fitCenter(cgImage: cg, width: w, height: h,lanczos:l)
    }
    
    private static func makeTransform(img:UIImage,w: CGFloat,h:CGFloat,scale:Guiso.ScaleType,l: Bool) -> UIImage? {
        return scale == .centerCrop ? TransformationUtils.centerCrop(image: img, width: w, height: h,lanczos:l) : TransformationUtils.fitCenter(image: img, width: w, height: h,lanczos: l)
    }
    
    
}
