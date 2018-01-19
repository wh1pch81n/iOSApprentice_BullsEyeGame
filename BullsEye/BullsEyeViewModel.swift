//
//  ViewModel.swift
//  BullsEye
//
//  Created by Derrick Ho on 1/17/18.
//  Copyright © 2018 Derrick Ho. All rights reserved.
//

import Foundation

struct BullsEyeState {
    static let lowSliderValue: Int = 1 // lowest target value
    static let highSliderValue: Int = 10 // highest target value
    public var targetSliderValue: Int = 0
    
    public var userSliderValue: Int = lroundf(Float(BullsEyeState.highSliderValue + BullsEyeState.lowSliderValue) / 2.0)
    
    public var score: Int = 0
    public var round: Int = 1
}

extension BullsEyeState {
    var instructionString: String { return "Put the Bull's Eye as close as you can to: \(targetSliderValue)" }
    var scoreString: String { return "Score: \(score)" }
    var roundString: String { return "Round: \(round)" }
}

class BullsEyeViewModel {
    var state: BullsEyeState = BullsEyeState()
    
    var callback: (BullsEyeState) -> ()
    
    init(callback: @escaping (BullsEyeState) -> ()) {
        self.callback = callback
    }
    
    func refresh() {
        callback(state)
    }
    
    func chooseRandomTargetValue() {
        // normalize difference
        let diff = abs(BullsEyeState.highSliderValue - BullsEyeState.lowSliderValue) + 1
        let random_n = Int(arc4random_uniform(UInt32(diff)))
        // shift the random back offset by the lowest value
        let valueOffsetMin = min(BullsEyeState.lowSliderValue, BullsEyeState.highSliderValue) + random_n
        
        state.targetSliderValue = valueOffsetMin
    }
    
    func calculateScore() -> (diff: Int, score: Int) {
        let usersValue = state.userSliderValue
        let targetValue = state.targetSliderValue
        let maxScorePerRound = abs(BullsEyeState.highSliderValue - BullsEyeState.lowSliderValue)
        
        let diff = abs(usersValue - targetValue)
        let totalScore = maxScorePerRound - diff
        
        return (diff: diff, score: totalScore)
    }
    
    func beginNextRound() {
        var newState = BullsEyeState()
        newState.round = state.round + 1
        newState.score = state.score + calculateScore().score
        state = newState
        chooseRandomTargetValue()
    }
    
    func setUserValue(_ value: Int) {
        state.userSliderValue = value
    }
    
    func resetAndMakeNewGame(with state: BullsEyeState = BullsEyeState()) {
        self.state = state
    }
    
}
