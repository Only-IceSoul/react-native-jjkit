//
//  GuisoTransform.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit


class GuisoTransform: TransformProtocol {
    
    private var mLanczos = false
    private var mScale = Guiso.ScaleType.fitCenter
    init(scale:Guiso.ScaleType,l: Bool) {
        mLanczos = l
        mScale = scale
    }
    

    func transformGif(cg: CGImage, outWidth: CGFloat, outHeight: CGFloat) -> CGImage? {
        
        let resized = outWidth != -1 && outHeight != -1
        return resized ? makeTransform(cg:cg,w:outWidth,h:outHeight) : cg
        
    }
    
    func transformImage(img: UIImage, outWidth: CGFloat, outHeight: CGFloat) -> UIImage? {
        let resized = outWidth != -1 && outHeight != -1
        return resized ? makeTransform(img:img,w:outWidth,h:outHeight) : img
    }
    
    
    private func makeTransform(cg:CGImage,w: CGFloat,h:CGFloat) -> CGImage? {
        return mScale == .centerCrop ? TransformationUtils.centerCrop(cgImage: cg, width: w, height: h,lanczos:mLanczos) : TransformationUtils.fitCenter(cgImage: cg, width: w, height: h,lanczos:mLanczos)
    }
    
    private func makeTransform(img:UIImage,w: CGFloat,h:CGFloat) -> UIImage? {
        return mScale == .centerCrop ? TransformationUtils.centerCrop(image: img, width: w, height: h,lanczos:mLanczos) : TransformationUtils.fitCenter(image: img, width: w, height: h,lanczos: mLanczos)
    }
    
    
}
