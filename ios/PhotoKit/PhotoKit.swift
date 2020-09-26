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
    
    @objc func fetch(_ media:String?, resolve:@escaping RCTPromiseResolveBlock, rejecter:@escaping RCTPromiseRejectBlock){
        Guiso.get().getExecutor().doWork {
            var mAlbumList = [[String:Any]]()
            var mMediaList = [[String:Any]]()

            let albums = self.getAllAlbums()
             if albums.count > 0 {
                 for i in 0...(albums.count-1){
                     let a = albums[i]
                  let datas = PhotoKit.getAssets(fromCollection: a)
                   
                   if(datas.count > 0){
                      var ga = [String:Any]()
                         ga["count"] = datas.count
                         ga["id"] =  PhotoKit.generateId()
                         ga["name"] = a.localizedTitle

                         var firstItem = true
                          let type = media ?? "all"
                         for index in 0...datas.count-1{
                           let m = datas.object(at: index)
                      
                           var shouldContinue = false
                       switch type {
                           case "image":
                               shouldContinue = m.mediaType != .image
                               break
                           case "video":
                               shouldContinue = m.mediaType != .video
                               break
                           case "gif":
                               if let mt = m.value(forKey: "uniformTypeIdentifier") as? String {
                                  if mt == kUTTypeGIF as String{
                                      shouldContinue = false
                                  }else{
                                     shouldContinue = true
                                   }
                                  
                               }else{
                                   shouldContinue = true
                               }
                               break
                           case "photo":
                               shouldContinue = m.mediaType != .image
                               if !shouldContinue {
                                   if let mt = m.value(forKey: "uniformTypeIdentifier") as? String {
                                        if mt == kUTTypeGIF as String{
                                            shouldContinue = true
                                        }else{
                                           shouldContinue = false
                                         }
                                    
                                   }else{
                                     shouldContinue = true
                                   }
                               }
                                break
                            case "video_gif":
                                 shouldContinue = m.mediaType != .video
                                 if shouldContinue {
                                    if let mt = m.value(forKey: "uniformTypeIdentifier") as? String {
                                          if mt == kUTTypeGIF as String{
                                              shouldContinue = false
                                          }else{
                                             shouldContinue = true
                                           }
                                      
                                    }else{
                                       shouldContinue = true
                                    }
                                 }
                                break
                       case "video_photo":
                            shouldContinue = m.mediaType != .video
                            if shouldContinue {
                                if let mt = m.value(forKey: "uniformTypeIdentifier") as? String {
                                     if mt == kUTTypeGIF as String{
                                         shouldContinue = true
                                     }else{
                                        shouldContinue = false
                                      }
                                 
                                }else{
                                  shouldContinue = true
                                }
                            }
                            break
                           default:
                               shouldContinue = false
                           }

                           if shouldContinue {
                               continue
                           }
                           
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
                           if firstItem{
                               firstItem = false
                               ga["mediaType"] = media["mediaType"]
                               ga["uri"] = media["uri"]
                               mAlbumList.append(ga)
                           }
                             
                           mMediaList.append(media)
                         }
                         

                         
                     }//datas cond > 0
                 }//for albums
               
            }//albums count filtered
             
            resolve([mAlbumList,mMediaList])
       

        }

    }
    

    @objc func fetchAlbums(_ names:NSArray?,media:String?, resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock){
         Guiso.get().getExecutor().doWork {
             var mAlbumList = [[String:Any]]()
             var mMediaList = [[String:Any]]()
          
          
          if names == nil {
              resolve(nil)
          }else{
              var arr = [String]()
              for i in 0...(names!.count - 1){
                  let s = names!.object(at: i) as? String
                  if s != nil && !s!.isEmpty{
                      let rs = s!.folding(options: .diacriticInsensitive, locale: .current)
              
                      arr.append(rs)
                  }
              }
              
              if arr.count < 1 {
                  resolve(nil)
                  
              }else{
          
                  let albums = self.getAlbums(names: arr)
                    if albums.count > 0 {
                        for i in 0...(albums.count-1){
                            let a = albums[i]
                         let datas = PhotoKit.getAssets(fromCollection: a)
                          
                          if(datas.count > 0){
                             var ga = [String:Any]()
                                ga["count"] = datas.count
                                ga["id"] =  PhotoKit.generateId()
                                ga["name"] = a.localizedTitle

                                var firstItem = true
                                 let type = media ?? "all"
                                for index in 0...datas.count-1{
                                  let m = datas.object(at: index)
                             
                                  var shouldContinue = false
                                 
                      switch type {
                          case "image":
                              shouldContinue = m.mediaType != .image
                              break
                          case "video":
                              shouldContinue = m.mediaType != .video
                              break
                          case "gif":
                              if let mt = m.value(forKey: "uniformTypeIdentifier") as? String {
                                 if mt == kUTTypeGIF as String{
                                     shouldContinue = false
                                 }else{
                                    shouldContinue = true
                                  }
                                 
                              }else{
                                  shouldContinue = true
                              }
                              break
                              case "photo":
                                  shouldContinue = m.mediaType != .image
                                  if !shouldContinue {
                                      if let mt = m.value(forKey: "uniformTypeIdentifier") as? String {
                                           if mt == kUTTypeGIF as String{
                                               shouldContinue = true
                                           }else{
                                              shouldContinue = false
                                            }
                                       
                                      }else{
                                        shouldContinue = true
                                      }
                                  }
                                break
                            case "video_gif":
                                shouldContinue = m.mediaType != .video
                                if shouldContinue {
                                   if let mt = m.value(forKey: "uniformTypeIdentifier") as? String {
                                     if mt == kUTTypeGIF as String{
                                         shouldContinue = false
                                     }else{
                                        shouldContinue = true
                                      }
                                     
                                   }else{
                                      shouldContinue = true
                                   }
                                }
                               break
                              case "video_photo":
                                   shouldContinue = m.mediaType != .video
                                   if shouldContinue {
                                       if let mt = m.value(forKey: "uniformTypeIdentifier") as? String {
                                            if mt == kUTTypeGIF as String{
                                                shouldContinue = true
                                            }else{
                                               shouldContinue = false
                                             }
                                        
                                       }else{
                                         shouldContinue = true
                                       }
                                   }
                                   break
                                  default:
                                      shouldContinue = false
                                  }
                                  
                                  
                                  if shouldContinue {
                                      continue
                                  }
                                  
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
                                  if firstItem{
                                      firstItem = false
                                      ga["mediaType"] = media["mediaType"]
                                      ga["uri"] = media["uri"]
                                      mAlbumList.append(ga)
                                  }
                                    
                                  mMediaList.append(media)
                                }
                                

                                
                            }//datas cond > 0
                        }//for albums
                      
                  }//albums count filtered
                    
                 resolve([mAlbumList,mMediaList])
              }//names filtered

              } //names
          }//thread
          
    }

    func getAlbums(names:[String]) -> [PHAssetCollection]{
         let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil )
         let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
         var result = [PHAssetCollection]()
         if smartAlbums.count > 0 {
             for i in 0...(smartAlbums.count-1){
                 let a = smartAlbums.object(at: i)
                 if let n = a.localizedTitle {
                     let rs = n.folding(options: .diacriticInsensitive, locale: .current)
                     if names.contains(rs){
                         result.append(a)
                     }
                 }
             }
         }
         
         if userCollections.count > 0 {
             for i in 0...(userCollections.count-1){
               let a = userCollections.object(at: i)
               if let n = a.localizedTitle {
                  let rs = n.folding(options: .diacriticInsensitive, locale: .current)
                   if names.contains(rs){
                     result.append(a as! PHAssetCollection)
                   }
               }
             }
         }
         
         return result
     }
      
    func getAllAlbums() -> [PHAssetCollection]{
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil )
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        var result = [PHAssetCollection]()
        if smartAlbums.count > 0 {
            for i in 0...(smartAlbums.count-1){
                let a = smartAlbums.object(at: i)
                result.append(a)
            }
        }
        
        if userCollections.count > 0 {
            for i in 0...(userCollections.count-1){
                let a = userCollections.object(at: i)
                result.append(a as! PHAssetCollection)
            }
        }
        
        return result
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
                    GuisoUtils.getData(asset: asset) { (data) in
                        DispatchQueue.main.async { resolve(data?.base64EncodedString()) }
                        
                     }
                }else {  DispatchQueue.main.async {  resolve(nil) }  }
            }
            
         }else {DispatchQueue.main.async {  resolve(nil) } }
     }
 
    @objc func requestImage(_ data:[String:Any]?, resolve:@escaping RCTPromiseResolveBlock, rejecter:@escaping RCTPromiseRejectBlock){
        
        let identifier = data?["uri"] as? String
          var width = data?["width"] as? Int ?? 500
          var height = data?["height"] as? Int ?? 500
          let format = data?["format"] as? Int ?? 0
          let quality = data?["quality"] as? CGFloat ?? 1

        width = width < 20 ? 20 : width
        height = height < 20 ? 20 : height
         
        if identifier != nil && !identifier!.isEmpty{

           Guiso.get().getExecutor().doWork {
               if let asset = self.resolveAsset(identifier!){
                if asset.mediaType == .video {
                    GuisoUtils.getVideoThumbnail(asset, second: 1, exact: false) { (img, error) in
                        if img != nil{
                            if let image = TransformationUtils.fitCenter(image: img!, width: CGFloat(width), height: CGFloat(height),lanczos: false){
                            
                                let data = format == 0 ? image.jpegData(compressionQuality: quality)
                                : image.pngData()
                                    DispatchQueue.main.async {  resolve(data?.base64EncodedString()) }
                            }else {DispatchQueue.main.async {  resolve(nil) }}
                        }else{
                             DispatchQueue.main.async {  resolve(nil) }
                        }
                    }
                }else{
                    GuisoUtils.getImage(asset: asset, size: CGSize(width: width, height: height), contentMode: .aspectFit) { (image) in
                        if image != nil {
                            let data = format == 0 ? image!.jpegData(compressionQuality: quality)
                                : image!.pngData()
                            DispatchQueue.main.async {
                                resolve(data?.base64EncodedString())
                            }
                        }else {
                            DispatchQueue.main.async {  resolve(nil) }
                        }
                        
                    }
                }
                
               }else {  DispatchQueue.main.async {  resolve(nil) } }
           }
           
        }else {  DispatchQueue.main.async {  resolve(nil) } }
      
    }

    func resolveAsset(_ identifier:String)->PHAsset?{
          let result = Guiso.get().getAsset(identifier)
             if result.count > 0 { return result.firstObject }
             else { return nil }
    }
     
        
   @objc func constantsToExport() ->  [AnyHashable : Any]! {
       return ["image": "image",
       "video" : "video",
       "video_photo":"video_photo",
       "video_gif":"video_gif",
       "all":"all",
       "gif":"gif",
       "photo":"photo",
               "jpeg":0,
               "png":1,
               "AUTHORIZED" : 1,
                "UNDETERMINED" : 0,
                "DENIED" : 2,
                "cover" : 0,
                "contain" : 1]
   }
      
       
}
