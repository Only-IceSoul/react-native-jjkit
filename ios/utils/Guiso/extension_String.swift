//
//  extension_String.swift
//  Jjkit
//
//  Created by Juan J LF on 4/12/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import UIKit
import MobileCoreServices

extension String {
    
    
    func sizeOneLine(text: String,font:UIFont, cgSize: inout CGSize) {
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        
        //redondeo float
        cgSize.width =  ceil(boundingBox.width)
        cgSize.height = ceil(boundingBox.height)
    
    }

    
    func sizeHeight(width: CGFloat ,font:UIFont, cgSize: inout CGSize) {
           
           let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
           let boundingBox = self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
           
           //redondeo float
           cgSize.width =  ceil(boundingBox.width)
           cgSize.height = ceil(boundingBox.height)
       
    }
    func getExtImage() -> String {
        var format = "png"
        let imageFormats = ["jpg", "png","JPEG","jpeg","JPG","PNG"]
        if URL(string: self) != nil  {
         let ext = (self as NSString).pathExtension
            imageFormats.forEach { (f) in
                if f == ext {
                    format = ext
                }
            }
        }
        return format
    }
    
    func getExtVideo() -> String {
        var format = "mp4"
        let videoFormats = ["mp4", "mpg4","mov","MP4","MPG4","MOV"]
        if URL(string: self) != nil  {
            let ext = (self as NSString).pathExtension
            videoFormats.forEach { (f) in
                if f == ext {
                   format = ext
                }
            }
        }
        return format
    }
    
    func isValidExtImage() -> Bool {
        let imageFormats = ["jpg", "png","JPEG","jpeg","JPG","PNG"]
       if URL(string: self) != nil  {
           let ext = (self as NSString).pathExtension
           return imageFormats.contains(ext)
       }
       return false
    }
    func isValidExtVideo() -> Bool {
       let videoFormats = ["mp4", "mpg4","mov","MP4","MPG4","MOV"]
       if URL(string: self) != nil  {
           let ext = (self as NSString).pathExtension
           return videoFormats.contains(ext)
       }
       return false
    }
    
    func isValidWebScheme() -> Bool {
       if URL(string: self) != nil  {
          return self.range(of: "http", options: .caseInsensitive) != nil
        }
        return false
    }
    

    func isValidWebUrl() -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector?.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
         return match.range.length == self.utf16.count
        } else {
         return false
        }
    }
    
    

    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    var isMimeTypeImage: Bool {
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, self as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeImage)
    }
    var isMimeTypeGif: Bool {
           guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, self as CFString, nil)?.takeRetainedValue() else {
               return false
           }
           return UTTypeConformsTo(uti, kUTTypeGIF)
    }
    var isMimeTypeAudio: Bool {
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, self as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeAudio)
    }
    var isMimeTypeVideo: Bool {
        guard  let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, self as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeMovie)
    }
    
}
