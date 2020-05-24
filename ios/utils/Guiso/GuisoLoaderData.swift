//
//  GuisoLoaderData.swift
//  Guiso
//
//  Created by Juan J LF on 5/19/20.
//

import UIKit
import MediaPlayer

class GuisoLoaderData: LoaderProtocol {
    
    private var mOptions = GuisoOptions()
    private var mCallback: ((Any?,Guiso.LoadType)->Void)?
    func loadData(model: Any, width: CGFloat, height: CGFloat, options: GuisoOptions, callback: @escaping (Any?, Guiso.LoadType) -> Void) {
        mOptions = options
        mCallback = callback
        if options.getAsGif() {
            sendResult(model,.data)
        }else{
            guard let data = model as? Data else {
                sendResult(nil,.data)
                return
            }
            if let img = UIImage(data: data){
                sendResult(img,.uiimg)
            }else{
                if let imgv = dataVideo(data){
                    sendResult(imgv,.uiimg)
                }else{

                guard let imga =  dataAudio(data)
                    else {
                        sendResult(nil,.data)
                        return
                     }
                    sendResult(imga,.uiimg)
                }
            }
    
        }
    }
    
    func sendResult(_ obj:Any?,_ type: Guiso.LoadType){
           mCallback?(obj,type)
           mCallback = nil
       }
    
    private func dataAudio(_ data:Data) -> UIImage? {
        do{
             let cacheDir = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
             let path = URL(fileURLWithPath: cacheDir).appendingPathComponent("guiso_audio.mp3")
             try data.write(to: path)
             return avAssetAudio(AVURLAsset(url: path))

         }catch let error as NSError {
             print("ImageHelper:error - getAudioArtWork Data -> Image generation -  failed with error: \(error)")
         return nil
         }
        
        
    }
    
    private func dataVideo(_ video:Data) -> UIImage? {
        
         do{
             let cacheDir = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
             let path = URL(fileURLWithPath: cacheDir).appendingPathComponent("guiso_video.mp4")
             try video.write(to: path)
             return avAssetVideo(AVURLAsset(url: path))
             
         }catch let error as NSError {
             print("GuisoLoaderData - dataVideo  -> Image generation -  failed with error: \(error)")
             return nil
         }
                
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
    
    private func avAssetVideo(_ asset: AVAsset) -> UIImage?{
           let generator = AVAssetImageGenerator(asset: asset)
                  generator.appliesPreferredTrackTransform = true
          if mOptions.getExactFrame() {
               generator.requestedTimeToleranceAfter = .zero
               generator.requestedTimeToleranceBefore = .zero
          }

          let timestamp = CMTime(seconds: mOptions.getFrameSecond(), preferredTimescale: 1)

          do {
              let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
              let newImage = UIImage(cgImage: imageRef)
              return newImage
          }
          catch (let error as NSError)
          {
              print("GuisoLoaderData avAssetVideo -> Image generation - failed with error: \(error)")
              return nil
          }
       }
    
    
    //MARK: Tracker
    func cancel() {
        mCallback = nil
    }
    
    func pause() {
        
    }
    
    func resume() {
        
    }
}
