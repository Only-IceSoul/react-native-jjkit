//
//  extension_String.swift
//  Jjkit
//
//  Created by Juan J LF on 4/12/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit

extension String {
    
    
    func sizeOneLine(text: String,font:UIFont, cgSize: inout CGSize) {
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        
        //redondeo float
        cgSize.width =  ceil(boundingBox.width)
        cgSize.height = ceil(boundingBox.height)
    
    }

    
    func sizeHeight(width: CGFloat ,font:UIFont, cgSize: inout CGSize) {
           
           let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
           let boundingBox = self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
           
           //redondeo float
           cgSize.width =  ceil(boundingBox.width)
           cgSize.height = ceil(boundingBox.height)
       
       }
    
}
