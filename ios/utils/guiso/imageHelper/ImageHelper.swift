//
//  TransformationUtils.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import UIKit
import AVFoundation
import Accelerate
import Photos
import MediaPlayer

class ImageHelper {
    
    enum Mode : Int {
        case fitCenter = 0,
        cropCenter
    }
    
    
    static func fitCenter(image: UIImage,width: CGFloat,height:CGFloat,lanczos:Bool = false) -> UIImage? {
        let inWidth = image.size.width
        let inHeight = image.size.height
        
        if(inWidth == width && inHeight == height){
            return image
        }
        
        let widthPercentage = width / inWidth
        let heightPercentage = height / inHeight
        let minPercentage = min(widthPercentage, heightPercentage)
        
        let targetWidth = round(minPercentage * inWidth)
        let targetHeight = round(minPercentage * inHeight)
        
        if(inWidth == targetWidth && inHeight == targetHeight){
           return image
        }
        
        let finalW = Int(minPercentage * inWidth)
        let finalH = Int(minPercentage * inHeight)
        
        return lanczos ? resizeVImage(image, CGFloat(finalW), CGFloat(finalH))
        : resizeImage(image, targetWidth: CGFloat(finalW), targetHeight:  CGFloat(finalH))
        
    }
    
    static func fitCenter(cgImage: CGImage,width: CGFloat,height:CGFloat, lanczos:Bool = false) -> CGImage? {
         let inWidth = CGFloat(cgImage.width)
         let inHeight = CGFloat(cgImage.height)
         
         if(inWidth == width && inHeight == height){
             return cgImage
         }
        
         let widthPercentage = width / inWidth
         let heightPercentage = height / inHeight
         let minPercentage = min(widthPercentage, heightPercentage)
         
         let targetWidth = round(minPercentage * inWidth)
         let targetHeight = round(minPercentage * inHeight)
         
         if(inWidth == targetWidth && inHeight == targetHeight){
            return cgImage
         }
        
        let finalW = Int(minPercentage * inWidth)
        let finalH = Int(minPercentage * inHeight)
        
        return lanczos ? resizeVImage(cgImage: cgImage, CGFloat(finalW), CGFloat(finalH)) :
                        resizeImage(cgImage,CGFloat(finalW), CGFloat(finalH))
         
     }
    
    
    static func centerCrop(image:UIImage,width:CGFloat,height:CGFloat,lanczos:Bool = false) -> UIImage? {
        let inWidth = image.size.width
        let inHeight = image.size.height

        if(inWidth == width && inHeight == height){
          return image
        }
              
        var dx:CGFloat = 0
        var dy:CGFloat = 0
        var scale:CGFloat = 1
        
        if inWidth * height > width * inHeight {
            scale = height / inHeight
            dx = (width - inWidth * scale) * 0.5
            dy = 0
        }else{
            scale = width / inWidth
            dy = (height - inHeight * scale) * 0.5
            dx = 0
        }
        
        
        let scaleW = scale * inWidth
        let scaleH = scale * inHeight
        
        let newSize = CGSize(width: width, height: height)
        let centerRect = CGRect(x: dx, y: dy, width: scaleW, height: scaleH)
        return  resizeImage(image, bitmapSize: newSize, drawRect: centerRect)
        
    }
    static func centerCrop(cgImage:CGImage,width:CGFloat,height:CGFloat, lanczos:Bool = false) -> CGImage? {
        let inWidth = CGFloat(cgImage.width)
        let inHeight = CGFloat(cgImage.height)
        
        if(inWidth == width && inHeight == height){
         return cgImage
        }
             
        var dx:CGFloat = 0
        var dy:CGFloat = 0
        var scale:CGFloat = 1

        if inWidth * height > width * inHeight {
           scale = height / inHeight
           dx = (width - inWidth * scale) * 0.5
           dy = 0
        }else{
           scale = width / inWidth
           dy = (height - inHeight * scale) * 0.5
           dx = 0
        }


        let scaleW = scale * inWidth
        let scaleH = scale * inHeight

        let newSize = CGSize(width: width, height: height)
        let centerRect = CGRect(x: dx, y: dy, width: scaleW, height: scaleH)
        
        return  resizeImage(cgImage:cgImage, bitmapSize: newSize, drawRect: centerRect)

    }
       
    
    static func getImage(url: URL)-> UIImage? {
        
        let path = url.path.replacingOccurrences(of: "/file:/", with: "")
        if FileManager.default.fileExists(atPath: path) {
            if let newImage = UIImage(contentsOfFile: path)  {
               return newImage
            } else {
                print("ImageHelper:error - getImageFile -> [Warning: file exists at \(path) :: Unable to create image]")
               return nil
            }

        } else {
             print("ImageHelper:error - getImageFile -> [Warning: file does not exist at \(path)]")
             return nil
        }
        
    }
    
    
    static func getImage(asset: PHAsset,_ completion: @escaping (UIImage?)->Void) {
   
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (img, info) in
            completion(img)
        }
   
      }
      

    static func getImageData(_ imageUrl: URL)-> Data? {
        let path = imageUrl.path.replacingOccurrences(of: "/file:/", with: "")
        if FileManager.default.fileExists(atPath: path) {
            do {
                let dataUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: dataUrl)
               return data
            } catch let error {
                print("ImageHelper:error - getImageData -> [Warning: file exists at \(path) :: Unable to create image error -> \(error)]")
               return nil
            }

        } else {
             print("ImageHelper:error - getImageData -> [Warning: file does not exist at \(path)]")
             return nil
        }
        
    }
    
    static func getImageData(asset: PHAsset,completion: @escaping (Data?)->Void) {
      
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
       
        PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, anyString, orientation, info) in

            completion(data)
        })

    }
    
    static func getCGImage(imgUrl: String)-> CGImage? {
        let url = URL(fileURLWithPath:imgUrl)
        let path = url.path.replacingOccurrences(of: "/file:/", with: "")
        if FileManager.default.fileExists(atPath: path) {
            let urlCorrect = URL(fileURLWithPath: path)

            guard let imageSource = CGImageSourceCreateWithURL(urlCorrect as NSURL, nil),
               let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            else {
                print("ImageHelper:error - getCGImageFile -> [Warning: file exists at \(path) :: Unable to create image]")
               return nil
            }
                return image
        } else {
             print("ImageHelper:error - getCGImageFile -> [Warning: file does not exist at \(path)]")
             return nil
        }
        
    }
    
    static func getVideoThumbnail(url:URL,second:Double) -> UIImage? {
       
        let vidURL = URL(fileURLWithPath:url.path)
        let asset = AVURLAsset(url: vidURL)
  
        
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        let timestamp = CMTime(seconds: second, preferredTimescale: 1)

        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            let newImage = UIImage(cgImage: imageRef)
            return newImage
        }
        catch (let error as NSError)
        {
            print("ImageHelper:error - getVideoThumbnail -> Image generation path: \(vidURL.path) -  failed with error: \(error)")
            return nil

        }
                
    }
    
    
    static func getVideoThumbnail(_ asset:PHAsset,second:Double, completion:@escaping (UIImage?,NSError?)-> Void) {

   
    let options = PHVideoRequestOptions()
    options.isNetworkAccessAllowed = false
        options.deliveryMode = .highQualityFormat

        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avasset, audiomix, info) in
            if avasset != nil {
                let generator = AVAssetImageGenerator(asset: avasset!)
                 generator.appliesPreferredTrackTransform = true

                 let timestamp = CMTime(seconds: second, preferredTimescale: 1)

                 do {
                     let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
                     let newImage = UIImage(cgImage: imageRef)
                     completion(newImage,nil)
                 }
                 catch (let error as NSError)
                 {
                      completion(nil,error)
                 }
            }else{
                completion(nil,nil)
            }
            
        }
      
    }
    
    static func getAudioArtWork(_ ipodUrl:String) -> UIImage? {
          
          let id = ipodUrl.substring(from: 32)
        
          let query = MPMediaQuery.songs()
          let urlQuery = MPMediaPropertyPredicate(value:id,forProperty: MPMediaItemPropertyPersistentID,comparisonType: .contains)
           query.addFilterPredicate(urlQuery);
        let mediaItems = query.items
        if let media = mediaItems?.first{
            if let artwork =  media.artwork {
                return artwork.image(at: CGSize(width: 100, height: 100))
            }
        }
        return nil
      }
      
    static func getAudioArtWrokFile(_ file:URL) -> UIImage? {
        
          let file = file.path.replacingOccurrences(of: "file://", with: "")
           let vidURL = URL(fileURLWithPath:file)
           let asset = AVURLAsset(url: vidURL)
     
        var result : UIImage? = nil
           
           for metadata in asset.metadata {
               guard let key = metadata.commonKey,
                let data = metadata.dataValue
                else{ continue }
            
                if key.rawValue == "artwork" {
                     result = UIImage(data: data)
                    break
                }
           }
              return result
    }
    
    
    static func getRect(cgImage:CGImage,width:CGFloat,height:CGFloat,_ scaleType: UIView.ContentMode) -> CGRect{
        switch scaleType {
        case .scaleAspectFill:
            return rectCenterCrop(cgImage: cgImage, width: width, height: height)
        case .scaleAspectFit:
            return rectFitCenter(cgImage: cgImage, width: width, height: height)
        default:
            return CGRect(x: 0, y: 0, width: width, height: height)
        }
    }
    
    static func getRect(image:UIImage,width:CGFloat,height:CGFloat,_ scaleType: UIView.ContentMode) -> CGRect{
          switch scaleType {
          case .scaleAspectFill:
              return rectCenterCrop(image: image, width: width, height: height)
          case .scaleAspectFit:
              return rectFitCenter(image: image, width: width, height: height)
          default:
              return CGRect(x: 0, y: 0, width: width, height: height)
          }
      }
    

    
  
    
    static func rectFitCenter(image: UIImage,width: CGFloat,height:CGFloat) -> CGRect {
        let inWidth = image.size.width
        let inHeight = image.size.height
        
        if(inWidth == width && inHeight == height){
            return CGRect(x: 0, y: 0, width: width, height: height)
        }
        
        let widthPercentage = width / inWidth
        let heightPercentage = height / inHeight
        let minPercentage = min(widthPercentage, heightPercentage)
        
        let targetWidth = round(minPercentage * inWidth)
        let targetHeight = round(minPercentage * inHeight)
        
        if(inWidth == targetWidth && inHeight == targetHeight){
           return CGRect(x: 0, y: 0, width: width, height: height)
        }
        
        let dx = (width - targetWidth) / 2
        let dy = (height - targetHeight) / 2
    
        return CGRect(x: dx, y: dy, width: targetWidth, height: targetHeight)
        
    }
    
    static func rectCenterCrop(image:UIImage,width:CGFloat,height:CGFloat) -> CGRect {
        let inWidth = image.size.width
        let inHeight = image.size.height
        
        if(inWidth == width && inHeight == height){
          return CGRect(x: 0, y: 0, width: width, height: height)
        }
             
        var dx:CGFloat = 0
        var dy:CGFloat = 0
        var scale:CGFloat = 1

        if inWidth * height > width * inHeight {
           scale = height / inHeight
           dx = (width - inWidth * scale) * 0.5
           dy = 0
        }else{
           scale = width / inWidth
           dy = (height - inHeight * scale) * 0.5
           dx = 0
        }
        let scaleW = scale * inWidth
        let scaleH = scale * inHeight
       return  CGRect(x: dx, y: dy, width: scaleW, height: scaleH)
    }
    
    static func rectFitCenter(cgImage: CGImage,width: CGFloat,height:CGFloat) -> CGRect {
        let inWidth = CGFloat(cgImage.width)
        let inHeight = CGFloat(cgImage.height)
        
        if(inWidth == width && inHeight == height){
            return CGRect(x: 0, y: 0, width: width, height: height)
        }
        
        let widthPercentage = width / inWidth
        let heightPercentage = height / inHeight
        let minPercentage = min(widthPercentage, heightPercentage)
        
        let targetWidth = round(minPercentage * inWidth)
        let targetHeight = round(minPercentage * inHeight)
        
        if(inWidth == targetWidth && inHeight == targetHeight){
           return CGRect(x: 0, y: 0, width: width, height: height)
        }
        
        let dx = (width - targetWidth) / 2
        let dy = (height - targetHeight) / 2
    
        return CGRect(x: dx, y: dy, width: targetWidth, height: targetHeight)
        
    }
    
    static func rectCenterCrop(cgImage:CGImage,width:CGFloat,height:CGFloat) -> CGRect {
        let inWidth = CGFloat(cgImage.width)
        let inHeight = CGFloat(cgImage.height)
        
        if(inWidth == width && inHeight == height){
          return CGRect(x: 0, y: 0, width: width, height: height)
        }
             
        var dx:CGFloat = 0
        var dy:CGFloat = 0
        var scale:CGFloat = 1

        if inWidth * height > width * inHeight {
           scale = height / inHeight
           dx = (width - inWidth * scale) * 0.5
           dy = 0
        }else{
           scale = width / inWidth
           dy = (height - inHeight * scale) * 0.5
           dx = 0
        }
        let scaleW = scale * inWidth
        let scaleH = scale * inHeight
       return  CGRect(x: dx, y: dy, width: scaleW, height: scaleH)
    }
    
}



// MARK: GIF

extension ImageHelper {
    
    static func makeGif(_ data:Data,_ width:CGFloat,_ height:CGFloat,_ scaleType: Guiso.ScaleType, lanczos: Bool = false) -> Gif? {
   
       guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
           print("makeImageGif:error -> maybe not exist data or wrong data")
           return nil
       }
    
    
        let gif = Gif()
       let count = CGImageSourceGetCount(source)
       var images = [CGImage]()


       for i in 0..<count {
          if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
            var transform: CGImage!
                switch scaleType {
                case .fitCenter:
                    transform = fitCenter(cgImage: image, width: width, height: height,lanczos: lanczos)
                    break
                case .centerCrop:
                    transform = centerCrop(cgImage: image, width: width, height: height,lanczos:lanczos)
                    break
                default:
                    transform = resizeImage(image, width, height)
                }
    
            guard let imgResult = transform else { return nil }
            images.append(imgResult)
          }
          
          let delaySeconds = giftDelayForImageAtIndex(Int(i),
              source: source)
          gif.delays.append(delaySeconds)
       }

        gif.frames = images
        let duration: Double = {
        var sum : Double = 0
         
        for val in gif.delays {
             sum += val
         }
         
         return sum
        }()

        gif.duration = duration

       return gif
    }


    static func makeGif(_ data:Data) -> Gif? {
       guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
           print("makeImageGif:error -> maybe not exist data or wrong data")
           return nil
       }
       let gif = Gif()
        gif.bytesCount = data.count
       let count = CGImageSourceGetCount(source)
        
        let cfProperties = CGImageSourceCopyProperties(source,nil)
       let gifProperties: CFDictionary = unsafeBitCast(
           CFDictionaryGetValue(cfProperties,
               Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
           to: CFDictionary.self)
       
       let loopCount: AnyObject? = unsafeBitCast(
           CFDictionaryGetValue(gifProperties,
               Unmanaged.passUnretained(kCGImagePropertyGIFLoopCount).toOpaque()),
           to: AnyObject.self)

        gif.loopCount = 0
        if let num = loopCount as? NSNumber {
            gif.loopCount = num.intValue
        }
    
        
       var images = [CGImage]()
       for i in 0..<count {
          if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
              images.append(image)
          }
          
          let delaySeconds = giftDelayForImageAtIndex(Int(i),
              source: source)
          gif.delays.append(delaySeconds)
       }

        gif.frames = images
        
       let duration: Double = {
        var sum : Double = 0
        for val in gif.delays {
              sum += val
          }
          return sum
       }()
        
        gif.duration = duration
        

       return gif
    }
    
    static func getGifDrawable(_ gif:Gif) -> GifDrawable {
             
       var framesResult = [CGImage]()
        
   
            for i in 0...(gif.frames.count-1){
              
                let img = gif.frames[i]
                let result =
                 resizeImage(img, CGFloat(img.width), CGFloat(img.height))
                if result != nil {
                    framesResult.append(result!)
                }
                
            }
        

        let result = GifDrawable()
        result.frames =  framesResult
        result.duration = gif.duration
        result.interval = result.duration / Double(result.frames.count)
        return  result

      }
    

    
    static func getUIImageAnimated(_ gif:Gif) -> UIImage?{
        let result = getGifDrawable(gif)
        let frames = result.frames.map { (cg) -> UIImage in
           return UIImage(cgImage: cg)
        }
        return UIImage.animatedImage(with: frames,
                                     duration: result.duration)
    }
  

    class func gcdForDelays(_ millis: Array<Int>) -> Int {
       if millis.isEmpty {
           return 1
       }
       var gcd = millis[0]
    
       for val in millis {
           gcd = gcdForPair(val, gcd)
          
       }
       
       return gcd
    }

    class func gcdForPair(_ a: Int, _ b: Int) -> Int {
         var a = a
         var b = b

         if a < b {
             let c = a
             a = b
             b = c
         }
         var rest: Int
         while true {
             rest = a % b
             
             if rest == 0 {
                 return b
             } else {
                 a = b
                 b = rest
             }
         }
     }

    class func giftDelayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
       var delay = 0.1
       
       let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
       let gifProperties: CFDictionary = unsafeBitCast(
           CFDictionaryGetValue(cfProperties,
               Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
           to: CFDictionary.self)
       
       var delayObject: AnyObject = unsafeBitCast(
           CFDictionaryGetValue(gifProperties,
               Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
           to: AnyObject.self)

       if delayObject.doubleValue == 0 {
           delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
               Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
       }
        
        
       delay = delayObject as! Double
      
       return delay
    }

    
    static func allAssets()-> [PHAsset]{
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil )
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        var array = [PHAsset]()
        if smartAlbums.count > 0 {
            for i in 0...(smartAlbums.count-1){
               let a = smartAlbums.object(at: i)
               let assets = getAssets(fromCollection: a )
                if assets.count > 0 {
                    for sii in 0...(assets.count-1){
                        array.append(assets.object(at: sii))
                    }
                }
            }
        }
        
        if userCollections.count > 0 {
           for i in 0...(userCollections.count-1){
              let c = userCollections.object(at: i)
            let assets = getAssets(fromCollection: c as! PHAssetCollection )
               if assets.count > 0 {
                   for ci in 0...(assets.count-1){
                       array.append(assets.object(at: ci))
                   }
               }
           }
        }
        return array
    }
    
    
    static func getAssets(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d",
        PHAssetMediaType.image.rawValue,
        PHAssetMediaType.video.rawValue)
        return PHAsset.fetchAssets(in: collection, options: options)
    }
    
    
}
