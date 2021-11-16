//
//  XTimer.swift
//  speedCubersTimer
//
//  Created by Pedro Luis Cabrera Acosta on 4/5/18.
//  Copyright © 2018 Pedro Luis Cabrera Acosta. All rights reserved.
//

import UIKit

class XTimer: NSObject {
    var timer:Timer? = nil
    var kind:TimerKind = TimerKind.normal
    var state:TimerState = TimerState.stopped
    override init(){}
    init(kind:TimerKind){
        self.kind = kind
    }
    func start(timeInterval ti: TimeInterval, target aTarget: Any, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool){
        self.state = .running
        self.timer = Timer.scheduledTimer(timeInterval: ti, target: aTarget, selector: aSelector, userInfo: userInfo, repeats: yesOrNo)
    }
    func stop(){
        self.state = .stopped
        self.timer?.invalidate()
        self.timer = nil
    }
}
