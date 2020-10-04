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
    
    @objc func fetch(_ query:[String:Any]?, resolve:@escaping RCTPromiseResolveBlock, rejecter:@escaping RCTPromiseRejectBlock){
        Guiso.get().getExecutor().doWork {
            
            var albumList = [[String:Any]]()
            var mediaList = [[String:Any]]()
            
            let media = query!["query"] as? String ?? "all"
            let names  = query!["names"] as? [String] ?? [String]()
            let limit = query!["limit"] as? Int ?? -1
            let offset = query!["offset"] as? Int ?? -1
            
            let albums = names.isEmpty ? self.getAllAlbums() : self.getAlbums(names: names)
            
            var justGif = false
            var allowGif = true
            
            let off = offset < 1 ? 0 : offset
            let li = limit < 1 ? -1 : limit
           
            var counter = 0
            var shouldEnd = false
            var counterLimit = 0
            
             if albums.count > 0 {
                 for i in 0...(albums.count-1){
                    
                    let album = albums[i]
                    var medias = PHFetchResult<PHAsset>()
                    switch media {
                    case "image":
                        medias = PhotoKit.getAssetsImages(fromCollection: album)
                        break
                    case "video":
                        medias = PhotoKit.getAssetsVideos(fromCollection: album)
                        break
                    case "gif":
                        medias = PhotoKit.getAssetsImages(fromCollection: album)
                        justGif = true
                        break
                    case "photo":
                        allowGif = false
                        medias = PhotoKit.getAssetsImages(fromCollection: album)
                        break
                    case "video_gif":
                        justGif = true
                        medias = PhotoKit.getAssets(fromCollection: album)
                        break
                    case "video_photo":
                        medias = PhotoKit.getAssets(fromCollection: album)
                        allowGif = false
                        break
                    default:
                        medias = PhotoKit.getAssets(fromCollection: album)
                        break
                    }
                    

                   if(medias.count > 0){
                    var a = [String:Any]()
                    var arrM = [[String:Any]]()
                       a["count"] = 0
                       a["id"] =  PhotoKit.generateId()
                       a["name"] = album.localizedTitle
                    var addThumbnail = true
                    
                    for id in 0...medias.count-1 {
                        let m = medias.object(at: id)
                        
                       
                        if(m.mediaType == .image && justGif && allowGif){
                            if let type = m.value(forKey: "uniformTypeIdentifier") as? String {
                                if !(type == kUTTypeGIF as String){
                                    continue
                                }
                            }
                        }
                        if (m.mediaType == .image && !allowGif){
                            if let type = m.value(forKey: "uniformTypeIdentifier") as? String {
                                if (type == kUTTypeGIF as String){
                                    continue
                                }
                            }
                        }
                        
                        counter += 1
                        if counter <= off {
                            continue
                        }
                        
                        a["count"] = a["count"] as! Int + 1
                        let assetResources = PHAssetResource.assetResources(for: m)
                        let name = assetResources.first?.originalFilename
                        var media = [String:Any]()
                        media["albumId"] = a["id"]
                        media["albumName"] = a["name"]
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
                        arrM.append(media)
                        
                        if addThumbnail {
                            a["mediaType"] = media["mediaType"]
                            a["uri"] = media["uri"]
                            addThumbnail = false
                        }
                        
                    
                        counterLimit += 1
                        if(li > 0 && counterLimit >= li){
                            shouldEnd = true
                        }
                        
                        if shouldEnd { break }
                            
                    } //for medias
                        
                    if(a["count"] as! Int > 0){
                        mediaList.append(contentsOf: arrM)
                        albumList.append(a)
                    }
                    
                }//medias cond > 0
                    
                    if shouldEnd { break }
                    
            }//for albums
               
        }//albums count filtered
             
        resolve([albumList,mediaList])
       

        }

    }
    


    
    @objc func fetchAlbums(_ media:String?,resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock){
        Guiso.get().getExecutor().doWork {
            var albumList = [[String:Any]]()
            let albums = self.getAllAlbums()
            var justGif = false
            var allowGif = true
            if(albums.count > 0){
                
                for i in 0...(albums.count-1){
                    let album = albums[i]
                    var medias = PHFetchResult<PHAsset>()
                    switch media {
                    case "image":
                        medias = PhotoKit.getAssetsImages(fromCollection: album)
                        break
                    case "video":
                        medias = PhotoKit.getAssetsVideos(fromCollection: album)
                        break
                    case "gif":
                        medias = PhotoKit.getAssetsImages(fromCollection: album)
                        justGif = true
                        break
                    case "photo":
                        allowGif = false
                        medias = PhotoKit.getAssetsImages(fromCollection: album)
                        break
                    case "video_gif":
                        justGif = true
                        medias = PhotoKit.getAssets(fromCollection: album)
                        break
                    case "video_photo":
                        medias = PhotoKit.getAssets(fromCollection: album)
                        allowGif = false
                        break
                    default:
                        medias = PhotoKit.getAssets(fromCollection: album)
                        break
                    }
                 
                  
                
                    if medias.count > 0 {
                        var a = [String:Any]()
                           a["count"] = 0
                           a["id"] =  PhotoKit.generateId()
                           a["name"] = album.localizedTitle
                        var addThumbnail = true
                        for id in 0...medias.count-1 {
                            let m = medias.object(at: id)
                            
                           
                            if(m.mediaType == .image && justGif && allowGif){
                                if let type = m.value(forKey: "uniformTypeIdentifier") as? String {
                                    if !(type == kUTTypeGIF as String){
                                        continue
                                    }
                                }
                            }
                            if (m.mediaType == .image && !allowGif){
                                if let type = m.value(forKey: "uniformTypeIdentifier") as? String {
                                    if (type == kUTTypeGIF as String){
                                        continue
                                    }
                                }
                            }
                            
                            a["count"] = a["count"] as! Int + 1
                            
                            if addThumbnail {
                                a["mediaType"] = m.mediaType == .image ? "image" : "video"
                                    if let type = m.value(forKey: "uniformTypeIdentifier") as? String {
                                        if type == kUTTypeGIF as String{
                                            a["mediaType"] = "gif"
                                        }

                                    }
                                a["uri"] = m.localIdentifier
                                addThumbnail = false
                            }
                                
                        } //for medias
                        if(a["count"] as! Int > 0){
                            albumList.append(a)
                        }
                    }//media count

                }//for albums
            }//album count
            
            resolve(albumList)
            
        }
    }

    func getAlbums(names:[String]) -> [PHAssetCollection]{
         let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil )
         let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
         var result = [PHAssetCollection]()
         if smartAlbums.count > 0 {
             for i in 0...(smartAlbums.count-1){
                 let a = smartAlbums.object(at: i)
                 if let n = a.localizedTitle {
                     if names.contains(n){
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
           options.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
           options.predicate = NSPredicate(format: "mediaType == %d || mediaType == %d",
           PHAssetMediaType.image.rawValue,
           PHAssetMediaType.video.rawValue)
           return PHAsset.fetchAssets(in: collection, options: options)
       }
    
   
       
        static func getAssetsImages(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
             let options = PHFetchOptions()
             options.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
             options.predicate = NSPredicate(format: "mediaType == %d",
             PHAssetMediaType.image.rawValue)
             return PHAsset.fetchAssets(in: collection, options: options)
       }
       
        static func getAssetsVideos(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
           let options = PHFetchOptions()
           options.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
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
                "contain" : 1,
                "NONE" : 1,
                "ALL" : 2,
                "DATA" : 3,
                "RESOURCE" : 4,
                "AUTOMATIC" : 0]
   }
      
       
}
