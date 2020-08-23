//
//  GameTimer.swift
//  WordPuzzle
//
//  Created by Abdul Basit on 23/08/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import Foundation

protocol GameTimerType {
    
    func timerAction(action: @escaping (() -> Void) )
    func start(timeInterval: Double)
    func stop()
    
}

final class GameTimer: GameTimerType {
    
    private var internalTimer: Timer?
    private var timerAction: (() -> Void)?
    private var interval: Double!
    
    func timerAction(action: @escaping () -> Void) {
        timerAction = action
    }
    
    func start(timeInterval: Double) {
        internalTimer = Timer.scheduledTimer(timeInterval: timeInterval,
                                             target: self,
                                             selector: #selector(timerDidFire),
                                             userInfo: nil, repeats: true)
        RunLoop.current.add(self.internalTimer!, forMode: RunLoop.Mode.common)
    }
    
    func stop() {
        internalTimer?.invalidate()
        internalTimer = nil
        timerAction = nil
    }
    
    @objc
    private func timerDidFire() {
        timerAction?()
    }
    
}
