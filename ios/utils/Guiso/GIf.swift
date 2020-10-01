//
//  GIf.swift
//  AnimationPractica
//
//  Created by Juan J LF on 4/23/20.
//  Copyright © 2020 Juan J LF. All rights reserved.
//

import UIKit

public class Gif : NSObject,NSCoding {
    
    public var delays : [Double] = []
    public var duration : Double = 0
    public var frames : [CGImage] = []
    public var loopCount : Int = 0
    public var bytesCount : Int = 0
    
    override init(){

    }
    
    public init(duration: Double ,loopCount:Int,bytesCount:Int,delays:[Double],frames: [CGImage]){
        self.frames = frames
        self.duration = duration
        self.loopCount = loopCount
        self.bytesCount = bytesCount
        self.delays = delays
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.bytesCount = aDecoder.decodeInteger(forKey: "bytesCount")
        self.loopCount = aDecoder.decodeInteger(forKey: "loopCount")
        self.duration = aDecoder.decodeDouble(forKey: "duration")
        self.delays = aDecoder.decodeObject(forKey: "delays") as? [Double] ?? [Double]()
        let fr = aDecoder.decodeObject(forKey: "frames") as? [UIImage] ?? [UIImage]()
        let cg = fr.map { (img) -> CGImage in
               img.cgImage!
        }
        self.frames = cg


    }
    public func encode(with aCoder: NSCoder)  {
          aCoder.encode(self.bytesCount, forKey: "bytesCount")
           aCoder.encode(self.loopCount, forKey: "loopCount")
           aCoder.encode(self.duration, forKey: "duration")

          let fr = self.frames.map { (cg) -> UIImage in
               UIImage(cgImage: cg)
           }
           aCoder.encode(fr, forKey: "frames")
          aCoder.encode(self.delays, forKey: "delays")
       }
}
