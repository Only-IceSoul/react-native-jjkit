//
//  GuisoUtil.swift
//  Guiso
//
//  Created by Juan J LF on 5/20/20.
//

import UIKit
import Photos

class GuisoUtils {
    
    static func imageColor(color: UIColor) -> UIImage? {

        let newSize = CGSize(width: 250, height: 250)
        let centerRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
       color.setFill()
       UIRectFill(centerRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
     static func getData(asset:PHAsset,_ completion: @escaping (Data?)->Void){
           let options = PHContentEditingInputRequestOptions()
           options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                       return true
                   }
           asset.requestContentEditingInput(with: options) { (value, info) in
               if asset.mediaType == .image {
                   if let url = value?.fullSizeImageURL {
                         do{
                             let imageData = try Data(contentsOf: url)
                             completion(imageData)
                         }catch let e as NSError {
                              completion(nil)
                             print("GuisoUtils - getDataFileManager:error -> ",e)
                         }
                   }else { completion(nil) }
               }
               if asset.mediaType == .video {
                   if let url = (value?.audiovisualAsset as? AVURLAsset)?.url {
                         do{
                             let imageData = try Data(contentsOf: url)
                             completion(imageData)
                         }catch let e as NSError {
                              completion(nil)
                             print("GuisoUtils - getDataFileManager:error -> ",e)
                         }
                   }else { completion(nil)   }
               }
            
           }
       }
    
    
    static func getVideoThumbnail(_ asset:PHAsset,second:Double,exact:Bool, completion:@escaping (UIImage?,NSError?)-> Void) {


     let options = PHVideoRequestOptions()
     options.isNetworkAccessAllowed = true
     options.deliveryMode = .highQualityFormat

         PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avasset, audiomix, info) in
             if avasset != nil {
                 let generator = AVAssetImageGenerator(asset: avasset!)
                  generator.appliesPreferredTrackTransform = true
                 if exact {
                     generator.requestedTimeToleranceAfter = .zero
                     generator.requestedTimeToleranceBefore = .zero
                 }

                  let timestamp = CMTime(seconds: second, preferredTimescale: 1)

                generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: timestamp)]) { (time, cg, time2, result, error) in
                            
                        if cg != nil {
                          completion(UIImage(cgImage: cg!),nil)
                        }else{
                            completion(nil,nil)
                        }
                    }
             }else{
                 completion(nil,nil)
             }
             
         }
       
     }

    static func getImage(asset: PHAsset,size:CGSize,contentMode: PHImageContentMode,_ completion: @escaping (UIImage?)->Void) {
       
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .highQualityFormat
             options.isSynchronous = true
         PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: contentMode, options: options) { (img, info) in
                completion(img)
            }
       
     }
    
}
