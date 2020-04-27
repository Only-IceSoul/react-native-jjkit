//
//  EngineKey.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit

class Key : Hashable{
    
    
    var hashValue: Int {
        var hasher = Hasher()
        self.hash(into: &hasher)
        return hasher.finalize()
    }
    
    func hash(into hasher: inout Hasher) {
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
    
    static func == (lhs: Key, rhs: Key) -> Bool {
        return lhs.hashValue == rhs.hashValue &&  lhs.toString() == rhs.toString()
    }
    
    
    
    
    private var mSignature:String = ""
    private var mWidth:CGFloat = -1
    private var mHeight:CGFloat = -1
    private var mScaleType: Guiso.ScaleType!
    private var mType : Guiso.MediaType!
    private var mFromFile : Bool!
    init(signature: String, width:CGFloat, height: CGFloat,scaleType: Guiso.ScaleType, type: Guiso.MediaType) {
        mSignature = signature
        mWidth = width
        mHeight = height
        mScaleType = scaleType
        mType = type
    }

     var ext = ""
    func toString() -> String {
       
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
            scale = "centerCrop"
            break
        case .fitCenter :
            scale = "fitCenter"
            break
        case .fill:
            scale = "fill"
        default:
            scale = ""
        }
        
      
         shortSignature()
        return "\(mSignature)-\(mWidth)x\(mHeight)x\(scale)\(ext)"
    }
    
    func getExtension() -> String {
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
             mSignature = mSignature.replacingOccurrences(of: " ", with: "")
             mSignature = mSignature.replacingOccurrences(of: "/", with: "1")
             mSignature = mSignature.replacingOccurrences(of: "www", with: "")
    }
    
}
