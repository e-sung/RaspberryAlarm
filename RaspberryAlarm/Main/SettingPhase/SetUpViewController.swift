//
//  SetUpAlarmViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit



class SetUpViewController: UIViewController, UINavigationControllerDelegate{
    
    @IBOutlet weak var timeToHeatAfterAsleepSlider: SliderSettingCell!
    @IBOutlet weak var timeToHeatBeforeAwakeSlider: SliderSettingCell!
    @IBOutlet weak var timeToSnoozeSlider: SliderSettingCell!
    @IBAction func confirmButtonHandler(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(TimeInterval(timeToHeatBeforeAwake), forKey: timeToHeatBeforeAwakeKey)
        UserDefaults.standard.set(TimeInterval(timeToHeatAfterAsleep), forKey: timeToHeatAfterAleepKey)
        UserDefaults.standard.set(TimeInterval(timeToSnooze), forKey: timeToSnoozeKey)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonHandler(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var timeToHeatBeforeAwake:TimeInterval!
    var timeToHeatAfterAsleep:TimeInterval!
    var timeToSnooze:TimeInterval!
    
    let defaultTimeToHeatBeforeAwake = 30.0*60.0
    let defaultTimeToHeatAfterAsleep = 30.0*60.0
    let defaultTimeToSnooze = 15.0*60.0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeToHeatAfterAsleepSlider.delegate = self
        timeToHeatBeforeAwakeSlider.delegate = self
        timeToSnoozeSlider.delegate = self
        
        if UserDefaults.standard.object(forKey: timeToHeatBeforeAwakeKey) == nil {
            timeToHeatBeforeAwake = defaultTimeToHeatBeforeAwake
            timeToHeatAfterAsleep = defaultTimeToHeatAfterAsleep
            timeToSnooze = defaultTimeToSnooze
        }else{
            timeToHeatBeforeAwake = UserDefaults.standard.double(forKey: timeToHeatBeforeAwakeKey)
            timeToHeatAfterAsleep = UserDefaults.standard.double(forKey: timeToHeatBeforeAwakeKey)
            timeToSnooze = UserDefaults.standard.double(forKey: timeToSnoozeKey)
        }
        timeToHeatBeforeAwakeSlider.quantity = Float(timeToHeatBeforeAwake/60)
        timeToHeatAfterAsleepSlider.quantity = Float(timeToHeatAfterAsleep/60)
        timeToSnoozeSlider.quantity = Float(timeToSnooze/60)
    }
}

extension SetUpViewController:SliderSettingCellDelegate{
    
    func didSliderValueChanged(_ changer: Int, _ changedValue: Float) {
        switch changer {
        case nightTimeChanger:
            timeToHeatAfterAsleep = TimeInterval(Int(changedValue) * 60)
        case morningTimeChanger:
            timeToHeatBeforeAwake = TimeInterval(Int(changedValue) * 60)
        case snoozeTimeChanger:
            timeToSnooze = TimeInterval(Int(changedValue) * 60)
        default:
            print("Unexpected changer tag")
        }
    }
}
