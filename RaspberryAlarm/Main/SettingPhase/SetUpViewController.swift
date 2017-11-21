//
//  SetUpAlarmViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class SetUpViewController: UIViewController, UINavigationControllerDelegate{
    
    @IBOutlet weak var timeToHeaetSlider: SliderSettingCell!
    @IBOutlet weak var timeToSnoozeSlider: SliderSettingCell!

    @IBAction func confirmButtonHandler(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(TimeInterval(timeToHeat), forKey: timeToHeatKey)
        UserDefaults.standard.set(TimeInterval(timeToSnooze), forKey: timeToSnoozeKey)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonHandler(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var timeToHeat:TimeInterval!
    var timeToSnooze:TimeInterval!
    let defaultTimeToHeat = 30.0*60.0
    let defaultTimeToSnooze = 15.0*60.0
    override func viewDidLoad() {
        super.viewDidLoad()
        timeToHeaetSlider.delegate = self
        timeToSnoozeSlider.delegate = self
        
        if UserDefaults.standard.object(forKey: timeToHeatKey) == nil {
            timeToHeat = defaultTimeToHeat
            timeToSnooze = defaultTimeToSnooze
        }else{
            timeToHeat = UserDefaults.standard.double(forKey: timeToHeatKey)
            timeToSnooze = UserDefaults.standard.double(forKey: timeToSnoozeKey)
        }
        timeToHeaetSlider.quantity = Float(timeToHeat/60)
        timeToSnoozeSlider.quantity = Float(timeToSnooze/60)
    }
}

extension SetUpViewController:SliderSettingCellDelegate{
    func didSliderValueChanged(_ changer: String, _ changedValue: Float) {
        if changer == "전기장판 시간" {
            timeToHeat = TimeInterval(changedValue * 60.0)
        }else if changer == "스누즈 시간"{
            timeToSnooze = TimeInterval(changedValue * 60.0)
        }
    }
}

