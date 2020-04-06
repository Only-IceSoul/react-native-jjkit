//
//  ClipRect.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/5/20.
//

import UIKit

@objc(ClipRect)
class ClipRect: UIView {
    
    private var mLayer = LayerClip()
    
    init() {super.init(frame: .zero)
        layer.mask = mLayer
    }
    override init(frame: CGRect) {super.init(frame: frame)
            layer.mask = mLayer
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override var bounds: CGRect{
        didSet{
            self.mLayer.onBoundsChange(bounds)
        }
    }
    
    @objc func setGravity(_ gravity: String?){
        var c = CALayer.Gravity.top
           switch gravity {
           case "bottom":
            c = .bottom
           case "left":
            c = .left
           case "right":
            c = .right
           default:
               c = .top
           }
        self.mLayer.setGravity(c)
       
    }
    
    @objc func setInset(_ inset: CGFloat){
        self.mLayer.setInset(inset: inset)
    
        
    }
    @objc func setProgress(_ progress: CGFloat){
        self.mLayer.setProgress(progress)
        
    }
  
    
 

}
