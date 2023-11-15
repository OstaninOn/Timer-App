//
//  Timer.swift
//  Timer App
//
//  Created by  aleksandr on 27.01.23.
//

import SwiftUI

@main
struct TimerApp: App {
    @StateObject var timerModel: TimerModel = .init()
    
    // MARK: - Scene Phase
    @Environment(\.scenePhase) var phase
    
    // MARK: - String Last Time Stamp
    @State var lastActiveTimeStamp: Date = Date()
    
    var body: some Scene {
        WindowGroup {
            TextTimer()
                .environmentObject(timerModel)
        }
        .onChange(of: phase) { newValue in
            if timerModel.isStarted {
                if newValue == .background {
                    lastActiveTimeStamp = Date()
                }
                if newValue == .active {
                    
                    // MARK: - Finding The Differece
                    let currentTimeStampDiff = Date() .timeIntervalSince(lastActiveTimeStamp)
                    if timerModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        timerModel.isStarted = false
                        timerModel.totalSeconds = 0
                        timerModel.isFinished = true
                    } else {
                        timerModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
        }
    }
}

