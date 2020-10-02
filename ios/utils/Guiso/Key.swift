//
//  EngineKey.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit

public class Key {
    
    
    
    private var mSignature:String = ""
    private var mExtra:String = ""
    private var mWidth:Int = -1
    private var mHeight:Int = -1
    private var mScaleType: Guiso.ScaleType!
    private var mIsGif = false
    private var mFromFile : Bool!
    private var mFrame : Int = 0
    private var mExactFrame = false
    private var mTransform = ""
    public init(signature: String,extra:String, width:CGFloat, height: CGFloat,scaleType: Guiso.ScaleType, frame:Double,exactFrame: Bool , isGif: Bool,transform:String) {
        mSignature = signature
        mExtra = extra
        mWidth = Int(width)
        mHeight = Int(height)
        mScaleType = scaleType
        mIsGif = isGif
        mFrame = Int(frame)
        mExactFrame = exactFrame
        mTransform = transform
    }


    public func toString() -> String {
        var exact = mExactFrame ? "t" : "f"
         var e = ""
        if mIsGif {
            e = "GIF"
            exact = "f"
            mFrame = 0
        }else{
   
            e = "IMG"
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
        
       
        if mSignature.isEmpty && mExtra.isEmpty { return ""}
      
        cleanSignature()
        cleanTransform()
        cleanExtra()
        
        var result = mSignature
        if !mExtra.isEmpty { result.append("_\(mExtra)")}
        if !mTransform.isEmpty { result.append("_\(mTransform)")}
        result.append("_\(mWidth)x\(mHeight)")
        if !scale.isEmpty { result.append("x\(scale)")}
       
        result.append("x\(mFrame)\(exact)")
        
        result.append(e)
        
        return result
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
    
    private func cleanExtra(){
        mExtra = mExtra.replacingOccurrences(of: " ", with: "_")
        mExtra = mExtra.replacingOccurrences(of: "/", with: "2")
        mExtra = mExtra.replacingOccurrences(of: ":", with: "z")
    }
    
}
