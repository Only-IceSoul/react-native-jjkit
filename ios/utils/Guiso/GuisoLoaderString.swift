//
//  GuisoLoaderFactory.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit
import MediaPlayer
import Photos

public class GuisoLoaderString : LoaderProtocol {
    
    public init() {
        
    }
    

    private var mUrl = ""
    private var mOptions : GuisoOptions!
    private var mUrlFile = false
    private var mCallback: ((Any?,Guiso.LoadType,String,Guiso.DataSource)-> Void)?
    
    private var mWebTask : URLSessionTask?
    private var mWebLoad : URLSessionTask?
    private var mGenerator: AVAssetImageGenerator?
    private var mPhId : PHImageRequestID?
    private var mPha : PHAsset?
    private var mPhaId : PHContentEditingInputRequestID?
  
    public func loadData(model: Any?, width: CGFloat, height: CGFloat, options: GuisoOptions,callback:@escaping (Any?,Guiso.LoadType,String,Guiso.DataSource)-> Void) {
        mCallback = callback
        guard let url = model as? String else {
            sendResult(nil,.data,"model is nil or not a string",.remote)
            return
        }
        mOptions = options
        mUrl = url
        if isWeb() {
            getWebMediaType { (type) in
                switch type {
                case .video:
                    self.urlVideo()
                break
                case .audio:
                    self.urlAudio()
                break
                default:
                    self.web()
                }
                self.mWebTask = nil
            }
        }else if isFile() {
            mUrlFile = true
            switch getFileMediaType() {
                case .audio:
                    self.urlAudio()
                break
                case .video:
                    self.urlVideo()
                break
                default:
                    file()
            }
        }else{
            if isIpod() {
                assetAudio()
            }else{
                guard let a = getAsset(identifier: mUrl)
                else{ callback(nil,.data,"failed get asset",.local)
                    return
                }
                if a.mediaType == .video {
                    assetVideo(a)
                }else{
                    asset(a)
                }
            }
        }

        
    }
    
   
   //MARK: fetcher web
    
    private func web(){
        let config = getConfigWeb()
          let session = URLSession(configuration: config)
        let request = getRequestWeb(mOptions.getHeader()?.getFields())
    mWebLoad = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                self.sendResult(nil,.data,error!.localizedDescription,.remote)
                return
            }
            
        if data != nil{
            self.sendResult(data,.data,"",.remote)
        }else{
            self.sendResult(data,.data,"got response nil",.remote)
        }
             
            
        }
        self.mWebLoad?.priority = getPriorityWeb()
        self.mWebLoad?.resume()
    }
    
    
    //MARK: File
    
    private func file(){
        guard let url = URL(string: mUrl),
            let data = try? Data(contentsOf: url)
                else {
            self.sendResult(nil,.data,"file : can't get the file",.local)
                   return
               }
        self.sendResult(data,.data,"",.local)
    }
    
    //MARk: fetcher Asset
    
    private func asset(_ asset:PHAsset){
      
        let options = PHContentEditingInputRequestOptions()
        options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
             return true
         }
        options.isNetworkAccessAllowed = true
        
        mPha = asset
       mPhaId = asset.requestContentEditingInput(with: options) { (value, info) in
            guard let url = value?.fullSizeImageURL else {
                self.sendResult(nil,.data,"asset: can't get image url",.local)
                return
            }
            do{
                let imageData = try Data(contentsOf: url)
                self.sendResult(imageData,.data,"",.local)
            }catch let e as NSError {
                self.sendResult(nil,.data,"asset: can't get the file with url \(url)",.local)
              
                print("GuisoLoaderString - asset:error -> ",e)
            }
            self.mPha = nil
            self.mPhaId = nil
        }
        
        
    }
    
    private func assetVideo(_ asset:PHAsset){
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = false
        options.deliveryMode = .highQualityFormat
        
       mPhId = PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avasset, audiomix, info) in
                if avasset != nil {
                    self.avAssetVideoAsync(avasset!)
                    
                }else{
                    self.sendResult(nil,.data,"asset: could not get avasset",.local)
                }
            self.mPhId = nil
        }
     
    }
    
    private func assetAudio(){
        let id = mUrl.substring(from: 32)
        let query = MPMediaQuery.songs()
        let urlQuery = MPMediaPropertyPredicate(value:id,forProperty: MPMediaItemPropertyPersistentID,comparisonType: .contains)
         query.addFilterPredicate(urlQuery);
        let mediaItems = query.items
        guard let media = mediaItems?.first,
           let artwork =  media.artwork else {
            self.sendResult(nil,.uiimg,"asset: could not get artwork",.local)
            return
          }
        let img = artwork.image(at: CGSize(width: 220, height: 220))
        self.sendResult(img,.uiimg,"",.local)
    }
    
   
    
    //MARK: fetcher URL
    private func urlVideo(){
        let header = mOptions.getHeader()?.getFields()
        guard let videoUrl = URL(string: mUrl) else {
            self.sendResult(nil,.uiimg,"url: not correct format ",.remote)
            return
        }
        let asset = header != nil && !mUrlFile ? AVURLAsset(url: videoUrl, options: ["AVURLAssetHTTPHeaderFieldsKey": header! ] ) : AVURLAsset(url: videoUrl)

          avAssetVideoAsync(asset)
         
    }

    private func avAssetVideoAsync(_ asset: AVAsset){
           let generator = AVAssetImageGenerator(asset: asset)
                  generator.appliesPreferredTrackTransform = true
          if mOptions.getExactFrame() {
               generator.requestedTimeToleranceAfter = .zero
               generator.requestedTimeToleranceBefore = .zero
          }
       
     
           mGenerator = generator
       
        let timestamp = CMTime(seconds: mOptions.getFrameSecond(), preferredTimescale: 1)
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: timestamp)]) { (time, cg, time2, result, error) in
                
            let typeSoruce:Guiso.DataSource = self.mUrlFile ? .local : .remote
            
            if cg != nil {
                self.sendResult(UIImage(cgImage: cg!), .uiimg,"",typeSoruce)
            }else{
                self.sendResult(nil, .uiimg,"asset: failed generating image from video",typeSoruce)
            }
        }
         
    }


    
    private func urlAudio(){
        let header = mOptions.getHeader()?.getFields()
       
       
        guard let audioUrl = URL(string: mUrl) else {
            self.sendResult(nil,.uiimg,"url: not correct format",.remote)
            return
        }
        let typeSoruce:Guiso.DataSource = self.mUrlFile ? .local : .remote
        let asset = header != nil && !mUrlFile ? AVURLAsset(url: audioUrl, options: ["AVURLAssetHTTPHeaderFieldsKey": header! ] ) : AVURLAsset(url: audioUrl)
               
        let result = avAssetAudio(asset)
        self.sendResult(result,.uiimg,"",typeSoruce)
    }
    private func avAssetAudio(_ asset:AVAsset) -> UIImage?{
        
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
    //MARK : Utils
    
    private func isIpod() -> Bool {
      return mUrl.contains("ipod-library")
    }

    private func isWeb() -> Bool {
      return  mUrl.isValidWebUrl() && !mUrl.contains("ipod-library") && !mUrl.contains("file://")
    }
       
    private func isFile() -> Bool {
      return mUrl.contains("file://")
    }
    
    
    
    private func getWebMediaType(completion: @escaping (Guiso.MediaType) -> Void) {
        var result = Guiso.MediaType.image
        var request = URLRequest(url: URL(string: mUrl)!)
        request.httpMethod = "HEAD"
        self.mWebTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(result)
            }else {
                guard let httpResponse = response as? HTTPURLResponse,
                     let ct = httpResponse.allHeaderFields["Content-Type"] as? String
                    else {
                       completion(result)
                       return
                    }
                      
                if ct.isMimeTypeVideo {
                    result = .video
                }else if ct.isMimeTypeAudio {
                    result = .audio
                }else {
                    result = .image
                }
                completion(result)
            }
        }
        self.mWebTask?.priority = getPriorityWeb()
        self.mWebTask?.resume()

    }
    
    private func getFileMediaType() -> Guiso.MediaType{
      var result = Guiso.MediaType.image
      if let url = URL(string: mUrl){
          if url.isMimeTypeGif {
              result = .gif
          }else if url.isMimeTypeVideo {
              result = .video
          }else if url.isMimeTypeAudio {
              result = .audio
          }else {
              result = .image
          }
      }
      return result
    }
    
    private func getConfigWeb() ->URLSessionConfiguration {
          let config = URLSessionConfiguration.default
             config.timeoutIntervalForRequest = TimeInterval(120)
             config.allowsCellularAccess = true
             config.httpShouldUsePipelining = true
         
         
         return config
     }
    
    private func getRequestWeb(_ header:[String:String]?) -> URLRequest {
        var request = URLRequest(url: URL(string: mUrl)!)
              request.allHTTPHeaderFields =  header
        return request
    }
    
    private func getAsset(identifier: String) -> PHAsset? {
           let assets = Guiso.get().getAsset(identifier)
        if assets.count > 0 {
            return assets.firstObject
            
        }else{
            return nil
        }
               
           
    }
    
    func getPriorityWeb() -> Float {
        switch mOptions.getPriority() {
        case .high:
            return 1
        case .low:
            return 0.5
        case .background:
            return 0.25
        default:
            return 0.75
        }
    }
    
    func sendResult(_ obj:Any?,_ type: Guiso.LoadType,_ error:String,_ source:Guiso.DataSource){
        mCallback?(obj,type,error,source)
        mCallback = nil
    }
    
    //MARK: Tracker
    public func cancel() {
        
        if mWebTask != nil {
            mWebTask?.cancel()
            mWebTask = nil
        }
        
        
        if mWebLoad != nil {
            mWebLoad?.cancel()
            mWebLoad = nil
        }
      
        if mGenerator != nil {
            mGenerator?.cancelAllCGImageGeneration()
            mGenerator = nil
        }
        
    

        if mPhaId != nil && mPha != nil {
            mPha?.cancelContentEditingInputRequest(mPhaId!)
            mPha = nil
            mPhaId = nil
        }
        if mPhId  != nil {
            PHImageManager.default().cancelImageRequest(mPhId!)
            mPhId = nil
        }
        
        if mCallback != nil {
            mCallback = nil
        }
      
        
    }
    
    public func pause() {
        if mWebLoad != nil {
           let state = mWebLoad!.state
           if  state == URLSessionTask.State.running  && state != .completed && state != .canceling {
                mWebLoad?.suspend()
           }
        }
        
    }
    
    public func resume() {
        if mWebLoad != nil {
            let state = mWebLoad!.state
            if  state == URLSessionTask.State.suspended  && state != .completed && state != .canceling {
                mWebLoad?.resume()
            }
        }
    }
}
