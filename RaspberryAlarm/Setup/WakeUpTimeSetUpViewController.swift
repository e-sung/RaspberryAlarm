//
//  WakeUpTimeSetUpViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 12..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class WakeUpTimeSetUpViewController: UIViewController {

    var timeValue:TimeInterval!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidAppear(_ animated: Bool) {
        datePicker.setDate(Date(timeInterval: timeValue, since: Date().midnight) , animated: true)
    }
    
    @IBAction private func timeChangeHandler(_ sender: UIDatePicker) {
        self.timeValue = sender.date.absoluteSeconds
    }
    
    @IBAction private func confirmButtonHandler(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToSetUpAlarmVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SetUpAlarmViewController
        nextVC.alarmItem.timeToWakeUp = self.timeValue
    }
}
