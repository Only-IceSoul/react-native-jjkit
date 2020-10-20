//
//  JJLoadingCircle.swift
//  MiCasaEnVenta
//
//  Created by Juan J LF on 13/4/19.
//  Copyright © 2019 Juan J LF. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    override var bounds: CGRect {
        didSet{
            
            self.circleLayer.frame = self.bounds
            setupPath(bounds: bounds)
        }
    }
    
    let circleLayer = CAShapeLayer()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.layer.addSublayer(circleLayer)
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.systemPurple.cgColor
        circleLayer.lineWidth = 4
        setupAnimations()
    }
    
    
    func setLineWidth(_ w:CGFloat) -> ProgressView{
        circleLayer.lineWidth = w
        return self
    }
    
    func setColor(_ color:UIColor){
        circleLayer.strokeColor = color.cgColor
    }
    
    
    private func setupPath(bounds: CGRect){
        let mi = min(bounds.width, bounds.height)
        circleLayer.lineWidth = mi * 0.09
        let r = ( (mi * 0.8 ) / 2) - circleLayer.lineWidth  / 2
        let circle = UIBezierPath(arcCenter: bounds.center, radius: r, startAngle: -.pi/3, endAngle: .pi*1.5, clockwise: true)
        circleLayer.path = circle.cgPath
    }
    
    
    private func setupAnimations(){
        let strokeAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.duration = 1
        strokeAnimation.beginTime = 0
        strokeAnimation.fillMode = .forwards
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let strokeAnimation2 = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
        
        strokeAnimation2.fromValue = 0
        strokeAnimation2.toValue = 1
        strokeAnimation2.duration = 1
        strokeAnimation2.beginTime = 1
        strokeAnimation2.fillMode = .forwards
        strokeAnimation2.isRemovedOnCompletion = false
        strokeAnimation2.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let rotation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.transform))
        
        rotation.valueFunction = CAValueFunction(name: CAValueFunctionName.rotateZ)
        rotation.fromValue = 0
        rotation.toValue =  CGFloat.pi * 2
        rotation.repeatCount = .greatestFiniteMagnitude
        rotation.duration = 0.9
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false
        
        
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [strokeAnimation,strokeAnimation2]
        
        animationGroup.duration  = 2
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = .forwards
        animationGroup.repeatCount = .greatestFiniteMagnitude
        
        circleLayer.add(animationGroup, forKey: nil)
        self.layer.add(rotation, forKey: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

