//
//  CropHelper.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 5/5/20.
//

import UIKit
import Accelerate


class CropHelper {
    

    static func crop(_ image:CGImage,imageRect:CGRect,cw:CGFloat,ch:CGFloat,crop: CGRect) -> CGRect {
        let w = crop.width / imageRect.width * CGFloat(image.width)
        let h = crop.height / imageRect.height * CGFloat(image.height)
        var x:CGFloat = crop.origin.x
        var y:CGFloat = crop.origin.y
        if imageRect.origin.x < 0 {
            x = abs(imageRect.origin.x) + crop.origin.x
        }else if imageRect.origin.x > 0 {
            x = crop.origin.x - imageRect.origin.x
        }
        if imageRect.origin.y < 0 {
            y = abs(imageRect.origin.y) + crop.origin.y
        }else if imageRect.origin.y > 0 {
              y = crop.origin.y - imageRect.origin.y
        }
        
        x = x / imageRect.width * CGFloat(image.width)
        y = y / imageRect.height * CGFloat(image.height)
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
  
}
