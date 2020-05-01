//
//  ImageWorker.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//


import UIKit
import Photos

class GuisoRequest : Runnable {
    
    private var mShouldTransform = false
    private var mUrl: String!
    private var mMediaType: Guiso.MediaType!
    private var mLoader : GuisoLoader!
    init(_ request: GuisoRequestBuilder,_ target: ViewTarget) {
        prepare(request)
        mLoader = GuisoLoader(request,target)
    }
    
    func prepare(_ request:GuisoRequestBuilder){
        mUrl = request.getUrl()
        mShouldTransform = request.getIsOverride()
        mMediaType  = request.getMediaType()
    }
    
    func run(){
        if !mLoader.checkIfNeedIgnore() {
            mLoader.updateIdentifier()
            if !mLoader.updateImageFromCache()  {
                
                if isWeb() {
                    if mMediaType == .gif{
                        updateWebGif()
                    }else{
                        updateWebImage()
                    }
                }else if isFile() {
                    if mMediaType == .gif {
                         updateFileGif()
                   }else {
                        switch getFileMediaType() {
                        case .audio:
                            updateFileAudio()
                        case .video:
                            updateFileVideo()
                        default:
                            updateFileImage()
                        }
                    }
                }else{
                    if mMediaType == .gif {
                        updateGif()
                    }else {
                        if isIpod() {
                             updateAudio()
                        }else{
                            switch getAssetMediaType() {
                                case .video:
                                    updateVideo()
                                default:
                                    updateImage()
                            }
                        }
                    }
                    
                }
             
                
            } //cache
        } // checkignore
    }
    
    func getAssetMediaType() -> Guiso.MediaType {
        let assets = Guiso.get().getAssets()
        var type = Guiso.MediaType.image
        assets.forEach { (a) in
            if a.localIdentifier == mUrl {
                switch a.mediaType {
                    case .video:
                        type = Guiso.MediaType.video
                    default:
                        type = Guiso.MediaType.image
                }
            }
        }
        return type
    }
  
    
    func updateImage(){
            if mShouldTransform {
                mLoader.updateTargetResize()
            }else {
        
                mLoader.updateTargetFullSize()
            }
    }
    

    func updateVideo(){
            if mShouldTransform {
                mLoader.updateTargetResizeVideo()
            }else {
               mLoader.updateTargetFullSizeVideo()
            }
    }
    
    func updateGif(){
        if mShouldTransform {
           mLoader.updateTargetResizeGif()
       }else {
          mLoader.updateTargetFullSizeGif()
       }
    }
    func updateAudio(){
        if mShouldTransform {
           mLoader.updateTargetResizeAudio()
       }else {
          mLoader.updateTargetFullSizeAudio()
       }
    }
    
    func updateWebGif(){
        if mShouldTransform {
            mLoader.updateTargetResizeWebGif()
        }else {
            mLoader.updateTargetFullSizeWebGif()
        }
    }
    
    func updateWebImage(){
        if mShouldTransform {
           mLoader.updateTargetResizeWeb()
        }else {
           mLoader.updateTargetFullSizeWeb()
        }
    }
    
    func updateFileGif(){
        if mShouldTransform {
            mLoader.updateTargetResizeFileGif()
        }else {
            mLoader.updateTargetFullSizeFileGif()
        }
    }
    func updateFileVideo(){
        if mShouldTransform {
             mLoader.updateTargetResizeFileVideo()
         }else {
             mLoader.updateTargetFullSizeFileVideo()
         }
    }
    func updateFileAudio(){
        if mShouldTransform {
            mLoader.updateTargetResizeFileAudio()
        }else {
            mLoader.updateTargetFullSizeFileAudio()
        }
    }
    func updateFileImage(){
        if mShouldTransform {
          mLoader.updateTargetResizeFile()
        }else {
          mLoader.updateTargetFullSizeFile()
        }
    }
    
  
    private func isIpod() -> Bool {
        return mUrl.contains("ipod-library")
    }
    
    private func isWeb() -> Bool {
        return  mUrl.isValidWebUrl() && !mUrl.contains("ipod-library") && !mUrl.contains("file://")
    }
         
    private func isFile() -> Bool {
        return mUrl.contains("file://")
    }
    
    private func getFileMediaType() -> Guiso.MediaType{
        var result = Guiso.MediaType.image
        if let url = URL(string: mUrl){
            if url.isMimeTypeImage {
                result = .image
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
    
    
}
