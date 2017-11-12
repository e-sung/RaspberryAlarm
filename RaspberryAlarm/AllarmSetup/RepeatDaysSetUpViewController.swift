//
//  RepeatDaySetUpViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 12..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class RepeatDaySetUpViewController: UIViewController, AlarmSetter {
    
    var alarmItem: AlarmItem!
    var newRepeatDays:[Day] = []
    
    @IBAction func confirmButtonHandler(_ sender: UIBarButtonItem) {
        for i in 1...7{
            let dayBt = self.view.viewWithTag(i) as! UIButton
            if dayBt.state == .selected{
                newRepeatDays.append(Day(rawValue: i)!)
            }
        }
        performSegue(withIdentifier: "fromRepeatDaysToMainSetUp", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SetUpAlarmViewController
        destinationVC.alarmItem.repeatDays = newRepeatDays
        print("on repeatDaysViewController:",destinationVC.alarmItem.repeatDays)
    }
    
    @IBAction func mondayTouchHandler(_ sender: UIButton) {
        toggleButtonState(sender)
    }
    
    @IBAction func tuesdayTouchHandler(_ sender: UIButton) {
        toggleButtonState(sender)
    }
    
    @IBAction func wedsdayTouchHandler(_ sender: UIButton) {
        toggleButtonState(sender)
    }
    
    @IBAction func thursdayTouchHandler(_ sender: UIButton) {
        toggleButtonState(sender)
    }
    @IBAction func fridayTouchHandler(_ sender: UIButton) {
        toggleButtonState(sender)
    }
    
    @IBAction func saterdayTouchHandler(_ sender: UIButton) {
        toggleButtonState(sender)
    }
    
    @IBAction func sundayTouchHandler(_ sender: UIButton) {
        toggleButtonState(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        for i in 1...7{
            if alarmItem.repeatDays.contains(Day(rawValue: i)!){
                let dayButton = self.view.viewWithTag(i) as! UIButton
                dayButton.isSelected = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleButtonState(_ button:UIButton){
        if button.isSelected {
            button.isSelected = false
        }else{
            button.isSelected = true
        }
    }
    
}
