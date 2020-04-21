//
//  PhotoKit.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

import Foundation
import Photos

@objc(PhotoKit)
class PhotoKit : NSObject, RCTBridgeModule {
    static func moduleName() -> String! {
        return  "PhotoKit"
    }
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc func isPermissionGranted(_ resolve: RCTPromiseResolveBlock, rejecter:RCTPromiseRejectBlock) {
          let status = PHPhotoLibrary.authorizationStatus()
          var value = false
          switch status {
          case .authorized:
             value =  true
             break
          case .denied,.restricted,.notDetermined:
              value =  false
             break
          default:
              value =  false
              print("unknow")
           }
           resolve(value)
       }
       
       @objc func permissionStatus(_ resolve: RCTPromiseResolveBlock, rejecter:RCTPromiseRejectBlock) {
          let status = PHPhotoLibrary.authorizationStatus()
          var value = 0
          switch status {
          case .authorized:
             value =  1
             break
          case .denied,.restricted:
              value =  2
             break
          default:
              value =  0
           }
          resolve(value)
       }
       
       @objc func requestPermission(_ resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock){
           PHPhotoLibrary.requestAuthorization()
           { (st) -> Void in
                 switch st {
                 case .authorized:
                      resolve(true)
                  break
                  default:
                     resolve(false)
                }
           }
       }
       
    private var mResolvePhotos : RCTPromiseResolveBlock?
       @objc func fetchPhotos(_ resolve:@escaping RCTPromiseResolveBlock, rejecter:@escaping RCTPromiseRejectBlock){
        mResolvePhotos = resolve
         Thread(target: self, selector: #selector(makePhotos), object: nil).start()
       
       }
    
    @objc func makePhotos(){
        var mAlbumList = [[String:Any]]()
           var mMediaList = [[String:Any]]()
        
            let sm = DispatchSemaphore(value: 0)
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil )
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)

            if smartAlbums.count > 0 {
                for i in 0...(smartAlbums.count-1){
                    let a = smartAlbums.object(at: i)
                   let datas = PhotoKit.getAssetsPhotos(fromCollection: a)
                  
                    if(!PhotoKit.shouldIgnoreAlbum(name: a.localizedTitle) && datas.count > 0){
                       var ga = [String:Any]()
                        ga["count"] = datas.count
                        ga["id"] =  PhotoKit.generateId()
                        ga["name"] = a.localizedTitle
                        ga["mediaType"] = "image"
                        let fo = datas.object(at: 0)
                        let op = PHContentEditingInputRequestOptions()
                          op.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                                         return true
                          }
                        fo.requestContentEditingInput(with: op, completionHandler: { (contentEditingInput, _) in
                          ga["data"] = contentEditingInput?.fullSizeImageURL?.absoluteString
                          sm.signal()
                        })
                           sm.wait()
                        mAlbumList.append(ga)
                      
                        for index in 0...datas.count-1{
                            let m = datas.object(at: index)
                            let assetResources = PHAssetResource.assetResources(for: m)
                            let name = assetResources.first?.originalFilename
                            var  media = [String:Any]()
                            media["albumId"] = ga["id"]
                            media["albumName"] = ga["name"]
                            media["displayName"] = name
                            media["date"] = m.modificationDate?.description
                            media["duration"] = m.duration
                            media["height"] = m.pixelHeight
                            media["width"] = m.pixelWidth
                            media["mediaType"] = "image"
                        let op = PHContentEditingInputRequestOptions()
                       op.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                                      return true
                       }
                          m.requestContentEditingInput(with: op, completionHandler: { (contentEditingInput, _) in
                           media["data"] = contentEditingInput?.fullSizeImageURL?.absoluteString
                           sm.signal()
                          })
                             sm.wait()
                            mMediaList.append(media)
                        }
                    }
                }
            }
            
            if userCollections.count > 0 {
                for i in 0...(userCollections.count-1){
                    let a = userCollections.object(at: i)
                    let datas = PhotoKit.getAssetsPhotos(fromCollection: a as! PHAssetCollection)
                    if( datas.count > 0){
                       var ga = [String:Any]()
                        ga["count"] = datas.count
                        ga["id"] =  PhotoKit.generateId()
                        ga["name"] = a.localizedTitle
                        ga["mediaType"] = "image"
                          let fo = datas.object(at: 0)
                        let op = PHContentEditingInputRequestOptions()
                             op.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                                            return true
                             }
                        
                         fo.requestContentEditingInput(with: op, completionHandler: { (contentEditingInput, _) in
                               ga["data"] = contentEditingInput?.fullSizeImageURL?.absoluteString
                               sm.signal()
                         })
                        sm.wait()
                         mAlbumList.append(ga)
                      
                        for index in 0...datas.count-1{
                            let m = datas.object(at: index)
                            let assetResources = PHAssetResource.assetResources(for: m)
                            let name = assetResources.first?.originalFilename
                           var media = [String:Any]()
                            media["albumId"] = ga["id"]
                            media["albumName"] = ga["name"]
                            media["displayName"] = name
                            media["date"] = m.modificationDate?.description

                            media["duration"] = m.duration
                            media["height"] = m.pixelHeight
                            media["width"] = m.pixelWidth
                            media["mediaType"] =  "image"

                           
                            let op = PHContentEditingInputRequestOptions()
                            op.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                                           return true
                            }
                            m.requestContentEditingInput(with:op , completionHandler: { (contentEditingInput, _) in
                                  media["data"] = contentEditingInput?.fullSizeImageURL?.absoluteString
                                  sm.signal()
                               })
                              sm.wait()
                              mMediaList.append(media)
                        }
                    }
                }
            }

            
              
        self.mResolvePhotos?([mAlbumList,mMediaList])
        self.mResolvePhotos = nil
        Thread.exit()
    }
       
    private var mResolveVideos: RCTPromiseResolveBlock?
       @objc func fetchVideos(_ resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock){
            mResolveVideos = resolve
            Thread(target: self, selector: #selector(makeVideos), object: nil).start()
       }
    
    @objc func makeVideos(){
        var mAlbumList = [[String:Any]]()
                   var mMediaList = [[String:Any]]()

                      let sm = DispatchSemaphore(value: 0)
                      let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil )
                      let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)

                      if smartAlbums.count > 0 {
                          for i in 0...(smartAlbums.count-1){
                              let a = smartAlbums.object(at: i)
                           let datas = PhotoKit.getAssetsVideos(fromCollection: a)
                            
                              if(!PhotoKit.shouldIgnoreAlbum(name: a.localizedTitle,extra: "Videos") && datas.count > 0){
                               var ga = [String:Any]()
                                  ga["count"] = datas.count
                                  ga["id"] =  PhotoKit.generateId()
                                  ga["name"] = a.localizedTitle
                                  ga["mediaType"] = "video"
                                  let fo = datas.object(at: 0)
                                  let op = PHContentEditingInputRequestOptions()
                                    op.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                                                   return true
                                    }
                                  fo.requestContentEditingInput(with: op, completionHandler: { (contentEditingInput, _) in
                                         ga["data"] = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString
                                       sm.signal()
                                  })
                                 sm.wait()
                                  mAlbumList.append(ga)
                                  for index in 0...datas.count-1{
                                      let m = datas.object(at: index)
                                      let assetResources = PHAssetResource.assetResources(for: m)
                                      let name = assetResources.first?.originalFilename
                              
                                   var media = [String:Any]()
                                      media["albumId"] = ga["id"]
                                      media["albumName"] = ga["name"]
                                      media["displayName"] = name
                                      media["date"] = m.modificationDate?.description
                                      media["duration"] = m.duration
                                      media["height"] = m.pixelHeight
                                      media["width"] = m.pixelWidth
                                      media["mediaType"] = "video"
                                  let op = PHContentEditingInputRequestOptions()
                                 op.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                                                return true
                                 }
                               
                                    m.requestContentEditingInput(with: op, completionHandler: { (contentEditingInput, _) in
                                      media["data"] = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString
                                        sm.signal()
                                    })
                                      sm.wait()
                                      mMediaList.append(media)
                                  }
                              }
                          }
                      }

                      if userCollections.count > 0 {
                          for i in 0...(userCollections.count-1){
                              let a = userCollections.object(at: i)
                              let datas = PhotoKit.getAssetsVideos(fromCollection: a as! PHAssetCollection)

                              if( datas.count > 0){
                               var ga = [String:Any]()
                                  ga["count"] = datas.count
                                  ga["id"] =  PhotoKit.generateId()
                                  ga["name"] = a.localizedTitle
                                  ga["mediaType"] = "video"
                                    let fo = datas.object(at: 0)
                                  let op = PHContentEditingInputRequestOptions()
                                       op.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                                                      return true
                                       }
                                 
                                   fo.requestContentEditingInput(with: op, completionHandler: { (contentEditingInput, _) in
                                      ga["data"] = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString
                                         sm.signal()
                                   })
                                   sm.wait()
                                   mAlbumList.append(ga)
                                  for index in 0...datas.count-1{
                                      let m = datas.object(at: index)
                                      let assetResources = PHAssetResource.assetResources(for: m)
                                      let name = assetResources.first?.originalFilename
                                   var media = [String:Any]()
                                      media["albumId"] = ga["id"]
                                      media["albumName"] = ga["name"]
                                      media["displayName"] = name
                                      media["date"] = m.modificationDate?.description
                                      media["duration"] = m.duration
                                      media["height"] = m.pixelHeight
                                      media["width"] = m.pixelWidth
                                      media["mediaType"] = "video"
                                      let op = PHContentEditingInputRequestOptions()
                                      op.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                                                     return true
                                      }
                                      m.requestContentEditingInput(with:op , completionHandler: { (contentEditingInput, _) in
                                          media["data"] = (contentEditingInput?.audiovisualAsset as? AVURLAsset)?.url.absoluteString
                                         sm.signal()
                                      })
                                     sm.wait()
                                      mMediaList.append(media)
                                  }
                           
                                
                              }
                          }
                      }
        self.mResolveVideos?([mAlbumList,mMediaList])
        self.mResolveVideos = nil
        Thread.exit()
    }
       
    private var mResolvePhotosVideos: RCTPromiseResolveBlock?
       @objc func fetchPhotosVideos(_ resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock){
           mResolvePhotosVideos = resolve
        Thread(target: self, selector: #selector(makePhotosVideos), object: nil).start()
    
       }
    
    @objc func makePhotosVideos(){
        var mAlbumList = [[String:Any]]()
                  var mMediaList = [[String:Any]]()
                 
                     let sm = DispatchSemaphore(value: 0)
                     let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil )
                     let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)

                     if smartAlbums.count > 0 {
                         for i in 0...(smartAlbums.count-1){
                             let a = smartAlbums.object(at: i)
                          let datas = PhotoKit.getAssets(fromCollection: a)
                           
                      if(!PhotoKit.shouldIgnoreAlbum(name: a.localizedTitle) && datas.count > 0){
                              var ga = [String:Any]()
                                 ga["count"] = datas.count
                                 ga["id"] =  PhotoKit.generateId()
                                 ga["name"] = a.localizedTitle
                                 let fo = datas.object(at: 0)
                                 let op = PHContentEditingInputRequestOptions()
                                   op.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                                                  return true
                                   }
                                 fo.requestContentEditingInput(with: op, completionHandler: { (contentEditingInput, _) in
                                   if fo.mediaType == .image
                                   {
                                       ga["data"] = contentEditingInput?.fullSizeImageURL?.absoluteString
                                      ga["mediaType"] = "image"
                                   }
                                   if fo.mediaType == .video
                                   {
                                        ga["data"] = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString
                                      ga["mediaType"] = "video"
                                   }
                                        sm.signal()
                                 })
                                 sm.wait()
                                 mAlbumList.append(ga)
                                 for index in 0...datas.count-1{
                                     let m = datas.object(at: index)
                                     let assetResources = PHAssetResource.assetResources(for: m)
                                     let name = assetResources.first?.originalFilename
                             
                                  var media = [String:Any]()
                                     media["albumId"] = ga["id"]
                                     media["albumName"] = ga["name"]
                                     media["displayName"] = name
                                     media["date"] = m.modificationDate?.description
                                     media["duration"] = m.duration
                                     media["height"] = m.pixelHeight
                                     media["width"] = m.pixelWidth
                                     media["mediaType"] = m.mediaType == .image ? "image" : "video"
                                 let op = PHContentEditingInputRequestOptions()
                                op.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                                               return true
                                }
                                   m.requestContentEditingInput(with: op, completionHandler: { (contentEditingInput, _) in
                                     if m.mediaType == .image
                                     {
                                         media["data"] = contentEditingInput?.fullSizeImageURL?.absoluteString
                                     }
                                     if m.mediaType == .video
                                     {
                                          media["data"] = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString
                                     }
                                         sm.signal()
                                   })
                                   sm.wait()
                                     mMediaList.append(media)
                                 }
                             }//cond > 0
                         }//for albums
                     }
                     
                     if userCollections.count > 0 {
                         for i in 0...(userCollections.count-1){
                             let a = userCollections.object(at: i)
                             let datas = PhotoKit.getAssets(fromCollection: a as! PHAssetCollection)

                             if( datas.count > 0){
                              var ga = [String:Any]()
                                 ga["count"] = datas.count
                                 ga["id"] =  PhotoKit.generateId()
                                 ga["name"] = a.localizedTitle
                                   let fo = datas.object(at: 0)
                                 let op = PHContentEditingInputRequestOptions()
                                      op.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                                                     return true
                                      }
                                  fo.requestContentEditingInput(with: op, completionHandler: { (contentEditingInput, _) in

                                 
                                    if fo.mediaType == .image
                                    {
                                        ga["data"] = contentEditingInput?.fullSizeImageURL?.absoluteString
                                         ga["mediaType"] = "image"
                                    }
                                    if fo.mediaType == .video
                                    {
                                         ga["data"] = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString
                                         ga["mediaType"] = "video"
                                    }
                                         sm.signal()
                                  })
                                   sm.wait()
                                   
                                  mAlbumList.append(ga)
                                 for index in 0...datas.count-1{
                                     let m = datas.object(at: index)
                                     let assetResources = PHAssetResource.assetResources(for: m)
                                     let name = assetResources.first?.originalFilename
                                 
                                  var media = [String:Any]()
                                     media["albumId"] = ga["id"]
                                     media["albumName"] = ga["name"]
                                     media["displayName"] = name
                                     media["date"] = m.modificationDate?.description
                                     media["duration"] = m.duration
                                     media["height"] = m.pixelHeight
                                     media["width"] = m.pixelWidth
                                     media["mediaType"] = m.mediaType == .image ? "image" : "video"
                                     let op = PHContentEditingInputRequestOptions()
                                     op.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                                                    return true
                                     }
                                     m.requestContentEditingInput(with:op , completionHandler: { (contentEditingInput, _) in
                                   
                                          if m.mediaType == .image
                                          {
                                              media["data"] = contentEditingInput?.fullSizeImageURL?.absoluteString
                                          }
                                          if m.mediaType == .video
                                          {
                                               media["data"] = (contentEditingInput?.audiovisualAsset as? AVURLAsset)?.url.absoluteString
                                          }
                                              sm.signal()
                                        })
                                      sm.wait()
                                       mMediaList.append(media)
                                 }
                             }
                         }
                     }
        self.mResolvePhotosVideos?([mAlbumList,mMediaList])
        self.mResolvePhotosVideos = nil
        Thread.exit()
    }
    
       static var mCurrentId = 0
       static func generateId() -> Int {
         mCurrentId += 1
         return mCurrentId
       }

       static func shouldIgnoreAlbum(name: String?, extra: String? = nil)-> Bool {
        var value = false
          if name == nil { return true }
          switch name {
          case "Hidden":
              value = true
              break
          case "Bursts":
              value = true
              break
          case "Recently Added":
              value = true
              break
          case "Animated":
              value = true
              break
          case "Recently Deleted":
              value = true
              break
          case "Unable to Upload":
              value = true
              break
          case "Camera Roll":
                value = true
                break
          case "Recents":
                value = true
                break
          default:
              value = false
          }
           if extra != nil && name == extra! { value = true }
          return value
       }
          
        static func getAssets(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
           let options = PHFetchOptions()
           options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
           options.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d",
           PHAssetMediaType.image.rawValue,
           PHAssetMediaType.video.rawValue)
           return PHAsset.fetchAssets(in: collection, options: options)
       }
       
        static func getAssetsPhotos(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
             let options = PHFetchOptions()
             options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
             options.predicate = NSPredicate(format: "mediaType == %d",
             PHAssetMediaType.image.rawValue)
             return PHAsset.fetchAssets(in: collection, options: options)
       }
       
        static func getAssetsVideos(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
           let options = PHFetchOptions()
           options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
           options.predicate = NSPredicate(format: "mediaType == %d",
           PHAssetMediaType.video.rawValue)
           return PHAsset.fetchAssets(in: collection, options: options)
       }
       
       static func getImage(_ imageUrl: String,completion: @escaping (UIImage?)->Void){
           let url = URL(fileURLWithPath:imageUrl)
           let path = url.path.replacingOccurrences(of: "/file:/", with: "")
           if FileManager.default.fileExists(atPath: path) {
               if let newImage = UIImage(contentsOfFile: path)  {
                   
                  completion(newImage)
             
               } else {
                   print("AlbumgetImage [Warning: file exists at \(path) :: Unable to create image]")
                   completion(nil)
               }

           } else {
                  completion(nil)
               print("AlbumgetImage [Warning: file does not exist at \(path)]")
           }
           
       }
       
       static func getImage(_ imageUrl: String,request:CGSize,completion: @escaping (UIImage?)->Void){
             let url = URL(fileURLWithPath:imageUrl)
             let path = url.path.replacingOccurrences(of: "/file:/", with: "")
             if FileManager.default.fileExists(atPath: path) {
                 if let newImage = UIImage(contentsOfFile: path)  {
                   let img = resizeImageSampling(image: newImage, request: request)
                   if img != nil {
                      completion(img)
                   }else{
                       print("getImageSampling [Warning: file exists at \(path) :: Failed sampling image]")
                       completion(nil)
                   }
               
                 } else {
                     print("getImageSampling [Warning: file exists at \(path) :: Unable to create image]")
                     completion(nil)
                 }

             } else {
                    completion(nil)
                 print("getImageSampling [Warning: file does not exist at \(path)]")
             }
             
         }
       
       
       static func getVideoThumbnail(_ imageUrl:String,seconds:Double,completion: @escaping (UIImage?)->Void){
           let file = imageUrl.replacingOccurrences(of: "file://", with: "")
           let vidURL = URL(fileURLWithPath:file)
           let asset = AVURLAsset(url: vidURL)

           let generator = AVAssetImageGenerator(asset: asset)
           generator.appliesPreferredTrackTransform = true

           let timestamp = CMTime(seconds: seconds, preferredTimescale: 1)

           do {
           let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
             let newImage = UIImage(cgImage: imageRef)
              completion(newImage)
       
           }
           catch (let error as NSError)
           {
               completion(nil)
             print("getVideoThumbnail Image generation failed with error \(error)")

           }
                      
       }
       static func getVideoThumbnail(_ imageUrl:String,seconds:Double,request:CGSize,completion: @escaping (UIImage?)->Void){
           let file = imageUrl.replacingOccurrences(of: "file://", with: "")
           let vidURL = URL(fileURLWithPath:file)
           let asset = AVURLAsset(url: vidURL)

           let generator = AVAssetImageGenerator(asset: asset)
           generator.appliesPreferredTrackTransform = true

           let timestamp = CMTime(seconds: seconds, preferredTimescale: 1)

           do {
               let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
               let newImage = UIImage(cgImage: imageRef)
               let img = resizeImageSampling(image: newImage, request: request)
               if img != nil {
                 completion(img)
               }else{
                  print("getVideoThumbnail [Warning: file exists at \(file) :: Failed sampling image]")
                  completion(nil)
               }

           }
           catch (let error as NSError)
           {
               completion(nil)
             print("getVideoThumbnail Image generation path: \(file) -  failed with error: \(error)")

           }
                      
       }
       
       static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
              let size = image.size

              let widthRatio  = targetSize.width  / size.width
              let heightRatio = targetSize.height / size.height

              // Figure out what our orientation is, and use that to form the rectangle
              var newSize: CGSize
              if(widthRatio > heightRatio) {
                  newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
              } else {
                  newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
              }

              // This is the rect that we've calculated out and this is what is actually used below
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

              // Actually do the resizing to the rect using the ImageContext stuff
              UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
              image.draw(in: rect)
              let newImage = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()

              return newImage
          }
       
       static func resizeImageSampling(image: UIImage, request: CGSize) -> UIImage? {
           
           let w = image.size.width
           let h = image.size.height
           var inSampleSize : CGFloat = 1
           
           if w > 0 && h > 0
               && ( w > request.width || h > request.height) {
               
               while h / inSampleSize > request.height || w / inSampleSize > request.width {
                   inSampleSize *= 2
               }
               let newWidth = w / inSampleSize
               let newHeight = h / inSampleSize
              let newSize = CGSize(width: newWidth, height: newHeight)
     
              let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
              UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
              image.draw(in: rect)
              let newImage = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()
               return newImage
           }else {
               return image
           }
       }
       
}
