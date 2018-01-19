//
//  BullsEyeViewModelTests.swift
//  BullsEyeViewModelTests
//
//  Created by Derrick Ho on 1/18/18.
//  Copyright © 2018 Derrick Ho. All rights reserved.
//

import XCTest
@testable import BullsEye

class BullsEyeViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_setUserValueSetsValue() {
        let sut = BullsEyeViewModel { _ in }
        
        // trigger
        sut.setUserValue(123)
        
        // test
        XCTAssertEqual(sut.state.userSliderValue, 123)
        
        // trigger
        sut.setUserValue(987)
        
        // test
        XCTAssertEqual(sut.state.userSliderValue, 987)
    }
    
    func test_calculateScore() {
        // The score is the absolute difference minus the offset from the target value
        
        let arrayOfInputs: [(input: (target: Int, user: Int), output: Int)] = [
            (input: (target: 1, user: 1), output: 9)
            , (input: (target: 1, user: 2), output: 8)
            , (input: (target: 1, user: 3), output: 7)
            , (input: (target: 1, user: 4), output: 6)
            , (input: (target: 1, user: 5), output: 5)
            , (input: (target: 1, user: 6), output: 4)
            , (input: (target: 1, user: 7), output: 3)
            , (input: (target: 1, user: 8), output: 2)
            , (input: (target: 1, user: 9), output: 1)
            , (input: (target: 1, user: 10), output: 0)
        ]
        
        for i in arrayOfInputs.enumerated() {
            let sut = BullsEyeViewModel { _ in }
            sut.state.targetSliderValue = i.element.input.target
            sut.state.userSliderValue = i.element.input.user
            
            // trigger
            let (_, resultScore) = sut.calculateScore()
            
            // test
            XCTAssertEqual(resultScore, i.element.output, "Failed test: \(i.offset)")
        }
        
    }
    
    func test_beginNextRound() {
        // verify that round in incremented and score goes up
        let sut = BullsEyeViewModel { _ in }
        sut.state.round = 55
        sut.state.score = 41
        
        // simulate 9 points
        sut.state.targetSliderValue = 1
        sut.state.userSliderValue = 1
        
        // trigger
        sut.beginNextRound()
        
        // test
        XCTAssertEqual(sut.state.round, 55 + 1) // verify round is incremented by one
        XCTAssertEqual(sut.state.score, 41 + 9)
    }
    
    func test_resetAndMakeNewGame() {
        let sut = BullsEyeViewModel { _ in }
        sut.state.round = 55
        sut.state.score = 41
        
        // simulate 9 points
        sut.state.targetSliderValue = 1
        sut.state.userSliderValue = 1
        
        // pretest test
        XCTAssertEqual(sut.state.round, 55) // should go back to first round
        XCTAssertEqual(sut.state.score, 41) // should go back to zero score
        XCTAssertEqual(sut.state.userSliderValue, 1) // slider should go back to default
        
        // trigger
        sut.resetAndMakeNewGame()
        
        // test
        XCTAssertEqual(sut.state.round, 1) // should go back to first round
        XCTAssertEqual(sut.state.score, 0) // should go back to zero score
        XCTAssertEqual(sut.state.userSliderValue, 6) // slider should go back to default
    }
}
