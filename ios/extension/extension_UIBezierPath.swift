//
//  extension_UIBezierPath.swift
//  AnimationPractica
//
//  Created by Juan J LF on 3/26/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit



extension UIBezierPath {
    

    func addRect(_ r:CGRect?){
        guard let rect = r else { return }
        move(to: rect.origin)
        addLine(to: CGPoint(x: rect.width, y: rect.origin.y))
        addLine(to: CGPoint(x: rect.width , y: rect.height))
        addLine(to: CGPoint(x: rect.origin.x, y: rect.height))
        addLine(to: rect.origin)
        close()
    }
    
}
