//
//  Cropper.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 5/5/20.
//

import UIKit

@objc(Cropper)
class Cropper : NSObject, RCTBridgeModule {
    

    static func moduleName() -> String! {
        return  "Cropper"
    }
    static func requiresMainQueueSetup() -> Bool {
        return true
    }

    @objc func makeCrop64(_ request:[String:Any]?, resolve: RCTPromiseResolveBlock, rejecter:RCTPromiseRejectBlock){
        let image = request?["image"] as? String
        let imgRect = request?["rect"] as? [String:Any?]
        let cw = request?["cw"] as? CGFloat
        let ch = request?["ch"] as? CGFloat
        let crop = request?["crop"]  as? [String:Any?]
       
    
        if image != nil && imgRect != nil && cw != nil && ch != nil && crop != nil
        && checkRect(rect: imgRect!) && checkRect(rect: crop!){

           guard
            let data = Data(base64Encoded: image!),
              let img = UIImage(data: data),
            let cg = img.cgImage,
           let r = dictToCGRect(imgRect!),
            let c = dictToCGRect(crop!)
            else { resolve(nil)
                return
            }
            let rf = CropHelper.crop(cg, imageRect: r, cw: cw!, ch: ch!, crop: c)
            
            guard let quality = request?["quality"] as? CGFloat,
                let format = request?["format"] as? Int,
                let resultcg  = cg.cropping(to: rf)
                else {
                    resolve(nil)
                    return
                 }
            
            guard let wr = request?["width"] as? CGFloat,
                  let hr = request?["height"] as? CGFloat
            else {
                let result = UIImage(cgImage: resultcg)
                let data = format == 0 ? result.jpegData(compressionQuality: quality) :
                 result.pngData()
                  resolve(data?.base64EncodedString())
                  return
            }
        
            if wr > 0 && hr > 0 {
                let resized = ImageHelper.fitCenter(cgImage: resultcg, width: wr, height: hr)
                if resized != nil {
                   let result = UIImage(cgImage: resized!)
                   let data = format == 0 ? result.jpegData(compressionQuality: quality) :
                      result.pngData()
                      resolve(data?.base64EncodedString())
                }else{
                    resolve(nil)
                }
            }else {
                let result = UIImage(cgImage: resultcg)
                let data = format == 0 ? result.jpegData(compressionQuality: quality) :
                result.pngData()
                resolve(data?.base64EncodedString())
            }
              
        }else {
            resolve(nil)
        }
        
    }
    
    @objc func makeCropStatic(_ request:[String:Any]?, resolve: RCTPromiseResolveBlock, rejecter:RCTPromiseRejectBlock){
          let image = request?["image"] as? String
          let imgRect = request?["rect"] as? [String:Any?]
          let cw = request?["cw"] as? CGFloat
          let ch = request?["ch"] as? CGFloat
          let crop = request?["crop"]  as? [String:Any?]
      
    
      
          if image != nil && imgRect != nil && cw != nil && ch != nil && crop != nil
          && checkRect(rect: imgRect!) && checkRect(rect: crop!){

             guard
             let url = URL(string: image!),
             let data = try? Data(contentsOf: url),
                let img = UIImage(data: data),
              let cg = img.cgImage,
             let r = dictToCGRect(imgRect!),
              let c = dictToCGRect(crop!)
              else { resolve(nil)
                  return
              }
              let rf = CropHelper.crop(cg, imageRect: r, cw: cw!, ch: ch!, crop: c)
              
              guard let quality = request?["quality"] as? CGFloat,
                  let format = request?["format"] as? Int,
                  let resultcg  = cg.cropping(to: rf)
                  else {
                      resolve(nil)
                      return
                   }
              
              guard let wr = request?["width"] as? CGFloat,
                    let hr = request?["height"] as? CGFloat
              else {
                  let result = UIImage(cgImage: resultcg)
                  let data = format == 0 ? result.jpegData(compressionQuality: quality) :
                   result.pngData()
                    resolve(data?.base64EncodedString())
                    return
              }
          
              if wr > 0 && hr > 0 {
                  let resized = ImageHelper.fitCenter(cgImage: resultcg, width: wr, height: hr)
                  if resized != nil {
                     let result = UIImage(cgImage: resized!)
                     let data = format == 0 ? result.jpegData(compressionQuality: quality) :
                        result.pngData()
                        resolve(data?.base64EncodedString())
                  }else{
                      resolve(nil)
                  }
              }else {
                  let result = UIImage(cgImage: resultcg)
                  let data = format == 0 ? result.jpegData(compressionQuality: quality) :
                  result.pngData()
                  resolve(data?.base64EncodedString())
              }
                
          }else {
              resolve(nil)
          }
          
      }
    
    func checkRect(rect:[String:Any?]) -> Bool{
        
        guard let l = rect["left"] as? CGFloat,
         let t = rect["top"] as? CGFloat,
        let r = rect["right"] as? CGFloat,
        let b = rect["bottom"] as? CGFloat
        else { return false }
    
        return l < r && t < b
    }
    
    func dictToCGRect(_ dic:[String:Any?]) -> CGRect? {
        guard let l = dic["left"] as? CGFloat,
            let t = dic["top"] as? CGFloat,
            let r = dic["right"] as? CGFloat,
            let b = dic["bottom"] as? CGFloat
            else { return nil }
    
        return CGRect(x: l, y: t, width: r - l, height: b - t)
    }
    
    @objc func constantsToExport() ->  [AnyHashable : Any]! {
        return ["jpeg":0,
                "png":1]
    }
       
}
