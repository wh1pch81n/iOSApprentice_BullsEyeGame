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
    static let highSliderValue: Int = 100 // highest target value
    public var targetSliderValue: Int = 0
    
    public var userSliderValue: Int = (BullsEyeState.highSliderValue + BullsEyeState.lowSliderValue) / 2
    
    public var score: Int = 0
    public var round: Int = 1
}

extension BullsEyeState {
    
    // Chooses a random target value
    mutating func setRandomTargetValue() {
        // normalize difference
        let diff = abs(BullsEyeState.highSliderValue - BullsEyeState.lowSliderValue)
        let random_n = Int(arc4random_uniform(UInt32(diff)))
        // shift the random back offset by the lowest value
        let valueOffsetMin = min(BullsEyeState.lowSliderValue, BullsEyeState.highSliderValue) + random_n
        
        targetSliderValue = Int(valueOffsetMin)
    }
    
    var instructionString: String { return "Put the Bull's Eye as close as you can to: \(targetSliderValue)" }
    var scoreString: String { return "Score: \(score)" }
    var roundString: String { return "Round: \(round)" }
}

class BullsEyeViewModel {
    var state: BullsEyeState = BullsEyeState() {
        didSet {
            callback(state)
        }
    }
    
    var callback: (BullsEyeState) -> ()
    
    init(callback: @escaping (BullsEyeState) -> ()) {
        self.callback = callback
    }
    
    func refresh() {
        callback(state)
    }
}
