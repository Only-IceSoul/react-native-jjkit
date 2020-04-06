//
//  CircleProgress.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/5/20.
//

import UIKit

@objc(CircleProgress)
class CircleProgress: UIView {
    
    private var mLayer = LayerCircleProgress()
    
    init() {super.init(frame: .zero)
        layer.addSublayer(mLayer)
    }
    override init(frame: CGRect) {super.init(frame: frame)
        layer.addSublayer(mLayer)
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override var bounds: CGRect{
        didSet{
            self.mLayer.onBoundsChange(bounds)
        }
    }
    
    @objc func setStrokeWidth(_ strokeWidth: NSNumber?){
        guard let size = strokeWidth as? CGFloat else {return }
        self.mLayer.setStrokeWidth(size)
    }
    
    @objc func setColors(_ colors: [String]?){
        let ca = [ UIColor.red.cgColor,UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.cyan.cgColor,
        UIColor.blue.cgColor,UIColor.magenta.cgColor,UIColor.red.cgColor]
        let c = colors == nil ? ca : colorsStringToColors(colors!)
        self.mLayer.setColor(c)
        
    }
    @objc func setPositions(_ positions: [NSNumber]?){
        self.mLayer.setPositions(positions)

        
    }
    @objc func setBackColors(_ colors: [String]?){
        let ca = [UIColor.lightGray.cgColor, UIColor.lightGray.cgColor]
        let c = colors == nil ? ca : colorsStringToColors(colors!)
        self.mLayer.setBackColor(c)


     }
    @objc func setBackPositions(_ positions: [NSNumber]?){
        self.mLayer.setBackPositions(positions)

    }
    
    @objc func setProgress(_ progress: CGFloat ){
        self.mLayer.setProgress(progress)
       
    }
    @objc func setCap(_ cp: String?){
        var c = CAShapeLayerLineCap.butt
        switch cp {
        case "square":
            c = .square
        case "round":
            c = .round
        default:
            c = .butt
        }
        self.mLayer.setCap(c)
    }
    
    
    
    private func colorsStringToColors(_ colors:[String])-> [CGColor]{
        var arr:[CGColor] = []
        
        colors.forEach { (c) in
            arr.append(UIColor.parseColor(c)!.cgColor)
        }
        return arr
        
    }

}
