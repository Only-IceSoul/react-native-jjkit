//
//  WeakTimer.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/26/20.
//

import Foundation


class WeakTimer {
    
    weak var mTarget : GifLayer?
    private var mSelector : Selector!
    init(target: GifLayer,selector: Selector) {
        mTarget =  target
        mSelector = selector
    }
    
    
    @objc func fire(_ timer:Timer){

        if(mTarget != nil)
        {
            mTarget?.perform(mSelector, with: timer)
        }
        else
        {
            timer.invalidate()
        }
    }
}
