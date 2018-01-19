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
    
    var easyMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleSlider()
        
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
    
    func styleSlider() {
        userSlider.setThumbImage(#imageLiteral(resourceName: "SliderThumb-Normal"), for: UIControlState.normal)
        userSlider.setThumbImage(#imageLiteral(resourceName: "SliderThumb-Highlighted"), for: UIControlState.highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        let trackLeftResizable = #imageLiteral(resourceName: "SliderTrackLeft").resizableImage(withCapInsets: insets)
        userSlider.setMinimumTrackImage(trackLeftResizable, for: UIControlState.normal)
        
        let trackRightResizable = #imageLiteral(resourceName: "SliderTrackRight").resizableImage(withCapInsets: insets)
        userSlider.setMaximumTrackImage(trackRightResizable, for: UIControlState.normal)
        
    }
    
    @IBAction func tappedResetGameButton(_ sender: Any) {
        viewModel.resetAndMakeNewGame()
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
        let newValue = lroundf(userSlider.value)
        viewModel.setUserValue(newValue)
        
        if easyMode {
            // Give the slider a "click" movement.
            userSlider.value = Float(newValue)
        }
    }
}

