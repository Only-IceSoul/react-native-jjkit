//
//  PhotoKit.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

import Foundation
import Photos
import MobileCoreServices


@objc(PhotoKit)
class PhotoKit : NSObject, RCTBridgeModule {
    
    
    
    
    static func moduleName() -> String! {
        return  "PhotoKit"
    }
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc func clearMemoryCache(_ resolve: RCTPromiseResolveBlock, rejecter:RCTPromiseRejectBlock){
        Guiso.get().cleanMemoryCache()
        resolve(true)
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
           }
           resolve(value)
       }
    
       @objc func requestPermission(_ resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock){
           PHPhotoLibrary.requestAuthorization()
           { (st) -> Void in
                 switch st {
                 case .authorized:
                      resolve(1)
                  break
                case .denied,.restricted:
                      resolve(2)
                       break
                  default:
                     resolve(0)
                }
           }
       }
    
    @objc func fetchPhotos(_ resolve:@escaping RCTPromiseResolveBlock, rejecter:@escaping RCTPromiseRejectBlock){
        Guiso.get().getExecutor().doWork {
        var mAlbumList = [[String:Any]]()
        var mMediaList = [[String:Any]]()


        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil )
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)

        if smartAlbums.count > 0 {
            for i in 0...(smartAlbums.count-1){
               let a = smartAlbums.object(at: i)
              let datas = PhotoKit.getAssetsPhotos(fromCollection: a)
             
               if( datas.count > 0){
                  var ga = [String:Any]()
                   ga["count"] = datas.count
                   ga["id"] =  PhotoKit.generateId()
                   ga["name"] = a.localizedTitle
                   ga["mediaType"] = "image"
                   let fo = datas.object(at: 0)
                   ga["uri"] = fo.localIdentifier
                   if let type = fo.value(forKey: "uniformTypeIdentifier") as? String {
                         if type == kUTTypeGIF as String{
                             ga["mediaType"] = "gif"
                         }
                         
                      }
                   mAlbumList.append(ga)
                 
                   for index in 0...datas.count-1{
                       let m = datas.object(at: index)
                       let assetResources = PHAssetResource.assetResources(for: m)
                       let name = assetResources.first?.originalFilename
                       var  media = [String:Any]()
                       media["albumId"] = ga["id"]
                       media["albumName"] = ga["name"]
                       media["displayName"] = name
                       media["date"] = Int64((m.modificationDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970))
                       media["duration"] = m.duration
                       media["height"] = m.pixelHeight
                       media["width"] = m.pixelWidth
                       media["mediaType"] = "image"
                       if let type = m.value(forKey: "uniformTypeIdentifier") as? String {
                         if type == kUTTypeGIF as String{
                             media["mediaType"] = "gif"
                         }
                         
                      }
                        media["uri"] = m.localIdentifier
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
                   
                   if let type = fo.value(forKey: "uniformTypeIdentifier") as? String {
                     if type == kUTTypeGIF as String{
                         ga["mediaType"] = "gif"
                     }
                     
                   }
                   ga["uri"] = fo.localIdentifier
                    mAlbumList.append(ga)
                 
                   for index in 0...datas.count-1{
                       let m = datas.object(at: index)
                       let assetResources = PHAssetResource.assetResources(for: m)
                       let name = assetResources.first?.originalFilename
                      var media = [String:Any]()
                       media["albumId"] = ga["id"]
                       media["albumName"] = ga["name"]
                       media["displayName"] = name
                       media["date"] = Int64((m.modificationDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970))

                       media["duration"] = m.duration
                       media["height"] = m.pixelHeight
                       media["width"] = m.pixelWidth
                       media["mediaType"] =  "image"
                       if let type = m.value(forKey: "uniformTypeIdentifier") as? String {
                          if type == kUTTypeGIF as String{
                              media["mediaType"] = "gif"
                          }
                          
                       }
                       media["uri"] = m.localIdentifier
                         mMediaList.append(media)
                   }
               }
            }
        }
        resolve([mAlbumList,mMediaList])
        }

    }
    

       
       @objc func fetchVideos(_ resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock){
        Guiso.get().getExecutor().doWork {
            var mAlbumList = [[String:Any]]()
            var mMediaList = [[String:Any]]()

            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil )
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)

            if smartAlbums.count > 0 {
              for i in 0...(smartAlbums.count-1){
                  let a = smartAlbums.object(at: i)
               let datas = PhotoKit.getAssetsVideos(fromCollection: a)
                
                  if datas.count > 0 {
                   var ga = [String:Any]()
                      ga["count"] = datas.count
                      ga["id"] =  PhotoKit.generateId()
                      ga["name"] = a.localizedTitle
                      ga["mediaType"] = "video"
                      let fo = datas.object(at: 0)
                         ga["uri"] = fo.localIdentifier
                      mAlbumList.append(ga)
                      for index in 0...datas.count-1{
                          let m = datas.object(at: index)
                          let assetResources = PHAssetResource.assetResources(for: m)
                          let name = assetResources.first?.originalFilename
                  
                       var media = [String:Any]()
                          media["albumId"] = ga["id"]
                          media["albumName"] = ga["name"]
                          media["displayName"] = name
                          media["date"] = Int64((m.modificationDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970))
                          media["duration"] = m.duration
                          media["height"] = m.pixelHeight
                          media["width"] = m.pixelWidth
                          media["mediaType"] = "video"
                     
                        media["uri"] = m.localIdentifier
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
                      ga["mediaType"] =  "video"
                        ga["uri"] = fo.localIdentifier
                       mAlbumList.append(ga)
                      for index in 0...datas.count-1{
                          let m = datas.object(at: index)
                          let assetResources = PHAssetResource.assetResources(for: m)
                          let name = assetResources.first?.originalFilename
                       var media = [String:Any]()
                          media["albumId"] = ga["id"]
                          media["albumName"] = ga["name"]
                          media["displayName"] = name
                          media["date"] = Int64((m.modificationDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970))
                          media["duration"] = m.duration
                          media["height"] = m.pixelHeight
                          media["width"] = m.pixelWidth
                          media["mediaType"] = "video"
                        media["uri"] = m.localIdentifier
                 
                          mMediaList.append(media)
                      }
               
                    
                  }
              }
            }
            resolve([mAlbumList,mMediaList])
        }
    }
  
       

    @objc func fetchAll(_ resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock){
    Guiso.get().getExecutor().doWork {
        var mAlbumList = [[String:Any]]()
        var mMediaList = [[String:Any]]()
       let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil )
       let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)

               if smartAlbums.count > 0 {
                   for i in 0...(smartAlbums.count-1){
                       let a = smartAlbums.object(at: i)
                    let datas = PhotoKit.getAssets(fromCollection: a)
                     
                if(datas.count > 0){
                        var ga = [String:Any]()
                           ga["count"] = datas.count
                           ga["id"] =  PhotoKit.generateId()
                           ga["name"] = a.localizedTitle
                           let fo = datas.object(at: 0)
                          ga["mediaType"] = fo.mediaType == .image ? "image" : "video"
                          if let type = fo.value(forKey: "uniformTypeIdentifier") as? String {
                              if type == kUTTypeGIF as String{
                                  ga["mediaType"] = "gif"
                              }
                              
                          }
                              ga["uri"] = fo.localIdentifier
                                      
                           
                           mAlbumList.append(ga)
                           for index in 0...datas.count-1{
                               let m = datas.object(at: index)
                               let assetResources = PHAssetResource.assetResources(for: m)
                               let name = assetResources.first?.originalFilename
                       
                            var media = [String:Any]()
                               media["albumId"] = ga["id"]
                               media["albumName"] = ga["name"]
                               media["displayName"] = name
                               media["date"] = Int64((m.modificationDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970))
                               media["duration"] = m.duration
                               media["height"] = m.pixelHeight
                               media["width"] = m.pixelWidth
                               media["mediaType"] = m.mediaType == .image ? "image" : "video"
                                media["uri"] = m.localIdentifier
                              if let type = m.value(forKey: "uniformTypeIdentifier") as? String {
                                  if type == kUTTypeGIF as String{
                                      media["mediaType"] = "gif"
                                  }
                                  
                              }
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
                              ga["mediaType"] = fo.mediaType == .image ? "image" : "video"
                       if let type = fo.value(forKey: "uniformTypeIdentifier") as? String {
                              if type == kUTTypeGIF as String{
                                  ga["mediaType"] = "gif"
                              }
                              
                          }
                                   ga["uri"] = fo.localIdentifier
                                                                       
                             
                            mAlbumList.append(ga)
                           for index in 0...datas.count-1{
                               let m = datas.object(at: index)
                               let assetResources = PHAssetResource.assetResources(for: m)
                               let name = assetResources.first?.originalFilename
                           
                            var media = [String:Any]()
                               media["albumId"] = ga["id"]
                               media["albumName"] = ga["name"]
                               media["displayName"] = name
                               media["date"] = Int64((m.modificationDate?.timeIntervalSince1970 ?? Date().timeIntervalSince1970))
                               media["duration"] = m.duration
                               media["height"] = m.pixelHeight
                               media["width"] = m.pixelWidth
                               media["mediaType"] = m.mediaType == .image ? "image" : "video"
                               if let type = m.value(forKey: "uniformTypeIdentifier") as? String {
                                  if type == kUTTypeGIF as String{
                                      media["mediaType"] = "gif"
                                  }
                                  
                              }
                              media["uri"] = m.localIdentifier
                                 mMediaList.append(media)
                           }
                       }
                   }
               }

        resolve([mAlbumList,mMediaList])

        }
    }

    
       static var mCurrentId = 0
       static func generateId() -> Int {
         mCurrentId += 1
         return mCurrentId
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
      
    

    @objc func requestRaw(_ identifier:String?,resolve:@escaping RCTPromiseResolveBlock, rejecter:@escaping RCTPromiseRejectBlock){
         if identifier != nil && !identifier!.isEmpty{
            Guiso.get().getExecutor().doWork {
                if let asset = self.resolveAsset(identifier!){
                    ImageHelper.getDataFileManager(asset: asset) { (data) in
                        if data != nil {
                                resolve(data!.base64EncodedString())
                        }
                     }
                }else {  DispatchQueue.main.async {  resolve(nil) }  }
            }
            
         }else { resolve(nil) }
     }
 
    @objc func requestImage(_ data:[String:Any]?, resolve:@escaping RCTPromiseResolveBlock, rejecter:@escaping RCTPromiseRejectBlock){
        
            let identifier = data?["uri"] as? String
              let width = data?["width"] as? Int ?? 500
              let height = data?["height"] as? Int ?? 500
              let format = data?["format"] as? Int ?? 0
              let quality = data?["quality"] as? CGFloat ?? 1
        
             
            if identifier != nil && !identifier!.isEmpty{
            
               Guiso.get().getExecutor().doWork {
                   if let asset = self.resolveAsset(identifier!){
                    ImageHelper.getImage(asset: asset, size: CGSize(width: width, height: height), contentMode: .aspectFit) { (image) in
                        if image != nil {
                            let data = format == 0 ? image!.jpegData(compressionQuality: quality)
                                : image!.pngData()
                            
                            resolve(data?.base64EncodedString())
                        }else {
                            resolve(nil)
                        }
                        
                    }
                   }else {  DispatchQueue.main.async {  resolve(nil) } }
               }
               
            }else { resolve(nil) }
      
    }

    func resolveAsset(_ identifier:String)->PHAsset?{
        let assets = Guiso.get().getAssets()
        var asset: PHAsset?
        for i in 0...(assets.count-1){
            let a = assets[i]
            if a.localIdentifier == identifier {
                 asset = a
                break
            }
        }
        return asset
    }
     
        
   @objc func constantsToExport() ->  [AnyHashable : Any]! {
       return ["fitCenter": 0,
               "centerCrop": 1,
               "jpeg":0,
               "png":1]
   }
      
       
}
