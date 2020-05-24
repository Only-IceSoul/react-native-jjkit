//
//  GuisoRequestTracker.swift
//  Guiso
//
//  Created by Juan J LF on 5/20/20.
//

import Foundation

public class GuisoRequestTracker {
    
    private var mRequest: GuisoRequest?
    private var mWorker: DispatchWorkItem?
    private var mPreload : GuisoPreload?
    
    init() {
        
    }
    
    func set(_ request: GuisoRequest?,_ worker:DispatchWorkItem?){
        mRequest = request
        mWorker = worker
    }
    func set(_ preload: GuisoPreload?,_ worker:DispatchWorkItem?){
       mPreload = preload
       mWorker = worker
    }
    public func resume(){
       mRequest?.resume()
       mPreload?.resume()
 
    }
    public func pause(){
        mRequest?.pause()
        mPreload?.pause()
    }
    
    public func cancel(){
        mRequest?.cancel()
        mPreload?.cancel()
        if mWorker?.isCancelled  == false {
            mWorker?.cancel()
        }
        mRequest = nil
        mWorker = nil
        mPreload = nil
        
    }
}
