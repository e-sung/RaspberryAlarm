//
//  WakeUpTimeSetUpViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 12..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class WakeUpTimeSetUpViewController: UIViewController {

    /**
     - ToDo
     현재 아이템의 timeToWakeUp을 기본으로 시작하기
    */
    private var timeValue:AlarmTime!
    
    @IBAction private func timeChangeHandler(_ sender: UIDatePicker) {
        self.timeValue = AlarmTime(with: sender.date)
    }
    
    @IBAction private func confirmButtonHandler(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToSetUpAlarmVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SetUpAlarmViewController
        nextVC.alarmItem.timeToWakeUp = self.timeValue
    }
}
