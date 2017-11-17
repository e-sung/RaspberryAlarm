//
//  RepeatDaySetUpViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 12..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class RepeatDaySetUpViewController: UIViewController{
    
    var dayButtons:[UIButton]{
        get{
            var buttonsToReturn:[UIButton] = []
            for i in 1...7{
                buttonsToReturn.append(self.view.viewWithTag(i) as! UIButton)
            }
            return buttonsToReturn
        }
    }
    var originalRepeatingDays:[Day]{
        get{
            let navControllerVC = navigationController as! SetUpAlarmNavigationViewController
            let alarmItem = DataCenter.main.alarmItems[navControllerVC.indexOfAlarmToSetUp]
            return alarmItem.repeatDays
        }
    }
    var newRepeatingDays:[Day]{
        get{
            var daysToReturn:[Day] = []
            for button in dayButtons{
                if button.state == .selected{
                    daysToReturn.append(Day(rawValue: button.tag)!)
                }
            }
            return daysToReturn
        }
    }

    @IBAction func confirmButtonHandler(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindRepeatDaysSetup", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SetUpAlarmViewController
        nextVC.alarmItem.repeatDays = newRepeatingDays
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
        color(the: dayButtons, of: originalRepeatingDays)
    }
    
    func color(the buttons:[UIButton], of repeatingDays:[Day]){
        for i in 1...7{
            if repeatingDays.contains(Day(rawValue: i)!){
                buttons[i-1].isSelected = true
            }
        }
    }
    
    func toggleButtonState(_ button:UIButton){
        if button.isSelected {
            button.isSelected = false
        }else{
            button.isSelected = true
        }
    }
}
