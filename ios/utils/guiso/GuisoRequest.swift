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
                if mUrl.isValidWebUrl() && !mUrl.contains("ipod-library") {
                     switch mMediaType {
                         case .gif:
                             updateWebGif()
                         default:
                             updateWebImage()
                     }
                }else {
                    if mMediaType == .gif {
                        updateFileGif()
                    }else {
                        if mUrl.contains("ipod-library"){
                             updateFileAudio()
                        }else{
                            switch getAssetMediaType() {
                                case .video:
                                    updateFileVideo()
                                default:
                                    updateFileImage()
                            }
                        }
                    }
                    
                }
                
            }
        }
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
  
    
    func updateFileImage(){
            if mShouldTransform {
                mLoader.updateTargetResizeManager()
            }else {
        
                mLoader.updateTargetFullSize()
            }
    }
    

    func updateFileVideo(){
            if mShouldTransform {
                mLoader.updateTargetResizeVideo()
            }else {
               mLoader.updateTargetFullSizeVideo()
            }
    }
    
    func updateFileGif(){
        if mShouldTransform {
           mLoader.updateTargetResizeGif()
       }else {
          mLoader.updateTargetFullSizeGif()
       }
    }
    func updateFileAudio(){
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
    
  
         
    
}
