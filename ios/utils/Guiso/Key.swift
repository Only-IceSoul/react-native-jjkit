//
//  EngineKey.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit
import CommonCrypto

public struct Key: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(mSignature)
        hasher.combine(mExtra)
        hasher.combine(mFrame)
        hasher.combine(mWidth)
        hasher.combine(mHeight)
        hasher.combine(mScaleType)
        hasher.combine(mTransform)
        hasher.combine(mIsAnimImg)
        hasher.combine(mExactFrame)
    }
    
    
    public static func == (lhs: Key, rhs: Key) -> Bool {
        return lhs.mSignature == rhs.mSignature
        && lhs.mExtra == rhs.mExtra
            && lhs.mFrame == rhs.mFrame
            && lhs.mWidth == rhs.mWidth
            && lhs.mHeight == rhs.mHeight
            && lhs.mScaleType == rhs.mScaleType
            && lhs.mTransform == rhs.mTransform
            && lhs.mIsAnimImg == rhs.mIsAnimImg
            && lhs.mExactFrame == rhs.mExactFrame
    }
    
    
    
    
    private var mSignature:String = ""
    private var mExtra:String = ""
    private var mWidth:Int = -1
    private var mHeight:Int = -1
    private var mScaleType: Guiso.ScaleType!
    private var mIsAnimImg = false
    private var mFrame : Int = 0
    private var mExactFrame = false
    private var mTransform = ""
    public init(signature: String,extra:String, width:CGFloat, height: CGFloat,scaleType: Guiso.ScaleType, frame:Double,exactFrame: Bool , isAnim: Bool,transform:String) {
        mSignature = signature
        mExtra = extra
        mWidth = Int(width)
        mHeight = Int(height)
        mScaleType = scaleType
        mIsAnimImg = isAnim
        mFrame = Int(frame)
        mExactFrame = exactFrame
        mTransform = transform
    }

    public func isValidSignature() -> Bool {
     
        return !"\(mSignature)\(mExtra)".isEmpty
        
    }
    
      func toString() -> String{
        return "\(mSignature)\(mExtra)\(mWidth)\(mHeight)\(mScaleType.rawValue)\(mFrame)\(mExactFrame)\(mTransform)\(mIsAnimImg)"
    }

    public func digestKey() -> Data? {
        guard let data = toString().data(using: .utf8)
        else{  return nil }
    
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        var failed = false
        data.withUnsafeBytes { (ptr)  in
            if let ptrAddress = ptr.baseAddress, ptr.count > 0 {
                _ = CC_SHA256(ptrAddress, CC_LONG(data.count), &hash)
            }else{
                failed = true
            }
        }
        return failed ? nil : Data(bytes: hash, count:  Int(CC_SHA256_DIGEST_LENGTH))
        
    }
    
}

