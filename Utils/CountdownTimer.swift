//
//  CountdownTimer.swift
//  Previando
//
//  Created by Franco Consoni on 31/08/2020.
//  Copyright © 2020 Kickser S.A. All rights reserved.
//

import Foundation

final class CountdownTimer {
    private var timer: Timer?
    private var seconds = 0
    private var action: (Int) -> Void = nop
    
    func start(at seconds: Int, atEveryStepDo action: @escaping (Int) -> Void) {
        self.seconds = seconds
        self.action = action
        
        self.startTimer()
    }
    
    func stop() {
        self.timer?.invalidate()
        
        self.timer = .none
    }
    
    private func startTimer() {
        self.timer?.invalidate()
        self.timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.step), userInfo: .none, repeats: true)

        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    @objc private func step() {
        self.seconds -= 1
        
        self.seconds >= 0 ? self.action(seconds) : self.stop()
    }
    
    deinit {
        self.stop()
    }
}
