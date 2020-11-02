//
//  extension_AttrString.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/17/20.
//

import UIKit

extension NSAttributedString {
    
    func sizeOneLine( cgSize: inout CGSize) {
         
         let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
   
        let boundingBox = self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
         
         //redondeo float
         cgSize.width =  ceil(boundingBox.width)
         cgSize.height = ceil(boundingBox.height)
     
     }
    
    

}
