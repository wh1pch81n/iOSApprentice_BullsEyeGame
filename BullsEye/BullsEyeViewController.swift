//
//  ViewController.swift
//  BullsEye
//
//  Created by Derrick Ho on 1/17/18.
//  Copyright © 2018 Derrick Ho. All rights reserved.
//

import UIKit

class BullsEyeViewController: UIViewController {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var userSlider: UISlider!
    @IBOutlet weak var sliderMinimumLabel: UILabel!
    @IBOutlet weak var sliderMaximumLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!

    var viewModel: BullsEyeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = BullsEyeViewModel(callback: { [unowned self] state in
            self.instructionLabel.text = state.instructionString
            self.sliderMinimumLabel.text = String(BullsEyeState.lowSliderValue)
            self.sliderMaximumLabel.text = String(BullsEyeState.highSliderValue)
            self.userSlider.minimumValue = Float(BullsEyeState.lowSliderValue)
            self.userSlider.maximumValue = Float(BullsEyeState.highSliderValue)
            self.userSlider.value = Float(state.userSliderValue)
            self.scoreLabel.text = state.scoreString
            self.roundLabel.text = state.roundString
        })
        
        viewModel.chooseRandomTargetValue()
        viewModel.refresh()
        
    }
    
    @IBAction func tappedHitMeButton(_ sender: Any) {
        let (diff, totalScore) = viewModel.calculateScore()
        let message = "You were off by \(diff), and scored \(totalScore) points"
        let alert = UIAlertController(title: "Results", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Next Round", style: UIAlertActionStyle.default) { [unowned self] _ in
            self.viewModel.beginNextRound()
            self.viewModel.refresh()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    @IBAction func sliderMoved(_ sender: Any) {
        viewModel.setUserValue(lroundf(userSlider.value))
    }
}

