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

 
    
    @objc func makeCrop(_ request:[String:Any]?, resolve: RCTPromiseResolveBlock, rejecter:RCTPromiseRejectBlock){
        let image = request?["image"] as? String
        let imgRect = request?["rect"] as? [String:Any?]
        let crop = request?["crop"]  as? [String:Any?]
        let rotation = request?["rotate"] as! CGFloat
        let flipVertical = request?["flipVertically"] as! Bool
        let flipHorizontal = request?["flipHorizontally"] as! Bool

        let op = request?["output"] as? [String:Any?]
        let quality = op?["quality"] as? CGFloat ?? 1
        let format = op?["format"] as? Int ?? 1
        let wr = op?["width"] as? CGFloat ?? -1
        let hr = op?["height"] as? CGFloat ?? -1
      
          if image != nil && imgRect != nil && crop != nil
          && checkRect(rect: imgRect!) && checkRect(rect: crop!){

             guard
             let data = load(image),
                let img = UIImage(data: data),
              let cg = img.cgImage,
             let r = dictToCGRect(imgRect!),
              let c = dictToCGRect(crop!)
              else { resolve(nil)
                  return
              }
        

            var imageResult:CGImage?
            if rotation > 0 || flipVertical || flipHorizontal {
                imageResult = CropHelper.flipContent(cg, vertical: flipVertical, horizontal: flipHorizontal)
                if rotation > 0  && imageResult != nil {
                    imageResult = getImageRotated(image: imageResult!, degree: rotation)
                }
            }else{
                imageResult = cg
            }

             guard imageResult != nil
               else {
                   resolve(nil)
                   return
               }
            
            let rf = CropHelper.crop(imageResult!, imageRect: r, crop: c)


            guard let resultcg  = imageResult!.cropping(to: rf)
            else {
               resolve(nil)
               return
            }
                   
          
            if wr > 0 && hr > 0 {
                let imgr = UIImage(cgImage: resultcg)
                guard
                let dat = imgr.pngData(),
                let imgd = UIImage(data: dat),
                let resized = TransformationUtils.fitCenter(image: imgd, width: wr, height: hr)
                else { resolve (nil )
                    return
                }

                let data = format == 0 ? resized.jpegData(compressionQuality: quality) :
                resized.pngData()
                resolve(data?.base64EncodedString())
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
    
    
    @objc func transform(_ request:[String:Any]?, resolve: RCTPromiseResolveBlock, rejecter:RCTPromiseRejectBlock){
        
        let image = request?["image"] as? String
        let rotation = request?["rotate"] as! CGFloat
        let flipVertical = request?["flipVertically"] as! Bool
        let flipHorizontal = request?["flipHorizontally"] as! Bool
        
        let op = request?["output"] as? [String:Any?]
        let quality = op?["quality"] as? CGFloat ?? 1
        let format = op?["format"] as? Int ?? 1
        let wr = op?["width"] as? CGFloat ?? -1
        let hr = op?["height"] as? CGFloat ?? -1
        
        guard let data = load(image),
              let img = UIImage(data: data),
              let cg = img.cgImage
            else { resolve(nil)
                return
        }
        
        var imageResult:CGImage? = cg
        if rotation > 0 || flipVertical || flipHorizontal {
            imageResult = CropHelper.flipContent(cg, vertical: flipVertical, horizontal: flipHorizontal)
            if rotation > 0 && imageResult != nil {
                imageResult = getImageRotated(image: imageResult!, degree: rotation)
            }
        }
        guard
            let resultcg = imageResult
            else {
                resolve(nil)
                return
             }
                    

        if wr > 0 && hr > 0 {
            let imgr = UIImage(cgImage: resultcg)
            guard
            let dat = imgr.pngData(),
            let imgd = UIImage(data: dat),
            let resized = TransformationUtils.fitCenter(image: imgd, width: wr, height: hr)
              else { resolve (nil )
                  return
            }

            let data = format == 0 ? resized.jpegData(compressionQuality: quality) :
              resized.pngData()
              resolve(data?.base64EncodedString())
        }else {
            let result = UIImage(cgImage: resultcg)
            let data = format == 0 ? result.jpegData(compressionQuality: quality) :
            result.pngData()
            resolve(data?.base64EncodedString())
        }
        
    }
    
    func load(_ model:String?) -> Data? {
        if model == nil { return nil }
        if model!.contains("base64,"){
            let s = model!.split(separator: ",")[1]
            let ss = String(s)
            let d = Data(base64Encoded: ss)
            return d
        }else if model!.contains("static;"){
            let s = model!.split(separator: ";")[1]
            let ss = String(s)
            guard let url = URL(string: ss),
            let data = try? Data(contentsOf: url)
            else { return nil }
            return data
        }else{
            return nil
        }
    }
    
    //clockwise
    func getImageRotated(image:CGImage,degree:CGFloat)-> CGImage? {
        let sizeRotated = CropHelper.getSizeRotated(image: image, degree: degree, cx: CGFloat(image.width/2), cy: CGFloat(image.height/2))
        guard
        let rotated = CropHelper.rotateContent(image,dstSize: sizeRotated, degree:degree)
        else{ return nil }
        
        return rotated
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
