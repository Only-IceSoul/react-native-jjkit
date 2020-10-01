//
//  EngineKey.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit

public class Key {
    
    
    
    private var mSignature:String = ""
    private var mWidth:Int = -1
    private var mHeight:Int = -1
    private var mScaleType: Guiso.ScaleType!
    private var mIsGif = false
    private var mFromFile : Bool!
    private var mFrame : Int = 0
    private var mExactFrame = false
    private var mTransform = ""
    public init(signature: String, width:CGFloat, height: CGFloat,scaleType: Guiso.ScaleType, frame:Double,exactFrame: Bool , isGif: Bool,transform:String) {
        mSignature = signature
        mWidth = Int(width)
        mHeight = Int(height)
        mScaleType = scaleType
        mIsGif = isGif
        mFrame = Int(frame)
        mExactFrame = exactFrame
        mTransform = transform
    }

     private var ext = ""
    public func toString(_ wfr: Bool = false) -> String {
        var exact = mExactFrame ? "t" : "f"
         var e = ""
        if mIsGif {
            ext = ".gif"
            e = "GIF"
            exact = "f"
            mFrame = 0
        }else{
            ext = ".\(self.mSignature.getExtImage())"
            e = ext
        }
      
        
        var scale = "error"
        switch mScaleType {
        case .centerCrop:
            scale = "cc"
            break
        case .fitCenter :
            scale = "fc"
            break
        default:
            scale = ""
        }
        
       
      
         cleanSignature()
         cleanTransform()
        return wfr ? "\(mSignature)_\(mTransform)\(mWidth)x\(mHeight)x\(scale)\(e)"
        : "\(mSignature)_\(mTransform)\(mWidth)x\(mHeight)x\(scale)x\(mFrame)\(exact)\(e)"
    }
    
  
    
    public func getExtension() -> String {
        return ext.replacingOccurrences(of: ".", with: "")
    }
    
    private func cleanSignature(){
     
        if mSignature.contains("ipod"){
            ipod()
        }
        
        all()
        
        
    
    }
    
    
    private func ipod(){
       mSignature = mSignature.substring(from: 32)
    }
    
    private func all(){
            mSignature = mSignature.replacingOccurrences(of: "https://www", with: "")
            mSignature = mSignature.replacingOccurrences(of: "http://www", with: "")
           mSignature = mSignature.replacingOccurrences(of: "https://", with: "")
            mSignature = mSignature.replacingOccurrences(of: "http://", with: "")
         mSignature = mSignature.replacingOccurrences(of: ".mp4", with: "")
         mSignature = mSignature.replacingOccurrences(of: ".mov", with: "")
        mSignature = mSignature.replacingOccurrences(of: ".jpg", with: "")
        mSignature = mSignature.replacingOccurrences(of: ".jpeg", with: "")
        mSignature = mSignature.replacingOccurrences(of: ".png", with: "")
         mSignature = mSignature.replacingOccurrences(of: ".mp3", with: "")
          mSignature = mSignature.replacingOccurrences(of: ".com/", with: "")
        mSignature = mSignature.replacingOccurrences(of: "file://", with: "")
             mSignature = mSignature.replacingOccurrences(of: " ", with: "_")
             mSignature = mSignature.replacingOccurrences(of: "/", with: "1")
            mSignature = mSignature.replacingOccurrences(of: ":", with: "y")
    }
    
    private func cleanTransform(){
        mTransform = mTransform.replacingOccurrences(of: " ", with: "_")
        mTransform = mTransform.replacingOccurrences(of: "/", with: "2")
        mTransform = mTransform.replacingOccurrences(of: ":", with: "z")
    }
    
}
