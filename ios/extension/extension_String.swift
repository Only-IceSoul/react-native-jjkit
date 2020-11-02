//
//  extension_String.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 11/1/20.
//

import UIKit



extension String {
    func sizeHeight(width: CGFloat ,font:UIFont, cgSize: inout CGSize) {
            
            let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            let boundingBox = self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
            
            //redondeo float
            cgSize.width =  ceil(boundingBox.width)
            cgSize.height = ceil(boundingBox.height)
        
     }
}
