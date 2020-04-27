//
//  GuisoExecutor.swift
//  react-native-jjkit
//
//  Created by Juan J LF on 4/22/20.
//

import Foundation


class Executor {
    
    private var mQueue : DispatchQueue!
    
    init(_ label:String){
        mQueue = DispatchQueue(label: label, attributes: .concurrent)
    }

    func doWork(_ item : Runnable){
        mQueue.async {
            item.run()
        }
    }
    
    func doWork(_ work: @escaping () -> Void){
        mQueue.async {
            work()
        }
    }

    func doWorkSync(_ item:Runnable){
        mQueue.sync {
            item.run()
        }
    }
    

    func doWorkBarrier(_ item:Runnable){
        let work = DispatchWorkItem(qos: .default, flags: .barrier, block: item.run)
        
        mQueue.async(execute: work)
    }
    
    func doTask(_ item:Runnable) -> DispatchWorkItem{
        let task = DispatchWorkItem(qos: .userInitiated, flags: .inheritQoS, block: item.run)
        mQueue.async(execute: task)
        return task
    }
    
}
