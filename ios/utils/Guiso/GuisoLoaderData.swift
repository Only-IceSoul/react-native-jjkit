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
    private var mCallback: ((Any?,Guiso.LoadType,String,Guiso.DataSource)->Void)?
    func loadData(model: Any?, width: CGFloat, height: CGFloat, options: GuisoOptions, callback: @escaping (Any?, Guiso.LoadType,String,Guiso.DataSource) -> Void) {
        mOptions = options
        mCallback = callback
        guard let data = model as? Data else {
            sendResult(nil,.data,"Data: model  is null or not a Data object",.remote)
             return
        }
        if options.getAsAnimatedImage() {
            sendResult(model,.data,"",.remote)
        }else{

            if let img = UIImage(data: data){
                sendResult(img,.uiimg,"",.remote)
            }else{
                if let imga =  dataAudio(data){
                    sendResult(imga,.uiimg,"",.remote)
                }else{

                    dataVideo(data)
                    
                }
            }
    
        }
    }
    
    func sendResult(_ obj:Any?,_ type: Guiso.LoadType,_ error:String,_ source:Guiso.DataSource){
           mCallback?(obj,type,error,source)
           mCallback = nil
       }
    
    private func dataAudio(_ data:Data) -> UIImage? {
        
        if let path = Guiso.get().writeToCacheFolder(data, name: "guiso_audio.mp3"){
            return avAssetAudio(AVURLAsset(url: path))
        }else{
            return nil
        }
        
    }
    
    private func dataVideo(_ video:Data) {
        
        if let path = Guiso.get().writeToCacheFolder(video, name: "guiso_video.mp4"){
            avAssetVideo(AVURLAsset(url: path))
        }else{
            sendResult(nil, .data,"data: failed parse data, data should be audio video gif or image ",.remote)
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
    
    private func avAssetVideo(_ asset: AVAsset){
    
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        if mOptions.getExactFrame() {
            generator.requestedTimeToleranceAfter = .zero
            generator.requestedTimeToleranceBefore = .zero
        }

        let timestamp = CMTime(seconds: mOptions.getFrameSecond(), preferredTimescale: 1)
        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: timestamp)]) { (time, cg, time2, result, error) in

            if cg != nil {
                self.sendResult(UIImage(cgImage: cg!), .uiimg,"",.remote)
            }else{
                self.sendResult(nil, .uiimg,"data: falied generating image from video",.remote)
            }
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
