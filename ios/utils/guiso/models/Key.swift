//
//  EngineKey.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit

class Key : Hashable{
    
 
    public var hashValue: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
    
    public func hash(into hasher: inout Hasher) {
        _ = toString()
        hasher.combine(mSignature)
         hasher.combine(mWidth)
         hasher.combine(mHeight)
         hasher.combine(mScaleType)
         hasher.combine(mType)
        hasher.combine(mScaleType)
        hasher.combine(mFromFile)
        hasher.combine(ext)
    }
    
    public static func == (lhs: Key, rhs: Key) -> Bool {
        return lhs.hashValue == rhs.hashValue &&  lhs.toString() == rhs.toString()
    }
    
    
    
    
    private var mSignature:String = ""
    private var mWidth:CGFloat = -1
    private var mHeight:CGFloat = -1
    private var mScaleType: Guiso.ScaleType!
    private var mType : Guiso.MediaType!
    private var mFromFile : Bool!
    private var mFrame : Double = 0
    private var mExactFrame = false
    public init(signature: String, width:CGFloat, height: CGFloat,scaleType: Guiso.ScaleType, frame:Double,exactFrame: Bool , type: Guiso.MediaType) {
        mSignature = signature
        mWidth = width
        mHeight = height
        mScaleType = scaleType
        mType = type
        mFrame = frame
        mExactFrame = exactFrame
    }

     private var ext = ""
   public func toString() -> String {
       
        switch mType {
        case .gif:
            ext = ".gif"
            break
        default:
            ext = ".\(self.mSignature.getExtImage())"
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
        
        let exact = mExactFrame ? "t" : "f"
      
         shortSignature()
        return "\(mSignature)_\(mWidth)x\(mHeight)x\(scale)x\(mFrame)\(exact)\(ext)"
    }
    
    public func getExtension() -> String {
        return ext.replacingOccurrences(of: ".", with: "")
    }
    
    private func shortSignature(){
     
        if mSignature.contains("ipod"){
            audio()
        }else {
            all()
        }
        
    
    }
    
  
    private func audio(){
       mSignature = mSignature.substring(from: 32)
    }
    
    private func all(){
        mSignature = mSignature.replacingOccurrences(of: "https://", with: "")
           mSignature = mSignature.replacingOccurrences(of: "http://", with: "")
         mSignature = mSignature.replacingOccurrences(of: "file://", with: "")
             mSignature = mSignature.replacingOccurrences(of: " ", with: "")
             mSignature = mSignature.replacingOccurrences(of: "/", with: "1")
             mSignature = mSignature.replacingOccurrences(of: "www", with: "")
       
    }
    
}
