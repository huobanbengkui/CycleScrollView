//
//  TimeExtension.swift
//  CycleScrollView
//
//  Created by huobanbengkui on 2018/7/4.
//  Copyright © 2018年 huobanbengkui. All rights reserved.
//

import Foundation

extension Timer{
    
    func resumeTimer(){
        if !isValid{
            return
        }
        fireDate = Date.distantPast
    }
    
    func pauseTimer(){
        if !isValid{
            return
        }
        fireDate = Date.distantFuture
    }
    
    func resumeTimerAfterTimeInterval(interval: TimeInterval){
        if !isValid{
            return
        }
        fireDate = Date.init(timeIntervalSinceNow: interval)
    }
}

