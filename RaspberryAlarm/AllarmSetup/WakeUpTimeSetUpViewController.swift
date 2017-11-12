//
//  WakeUpTimeSetUpViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 12..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class WakeUpTimeSetUpViewController: UIViewController {

    var alarmItem:AlarmItem!
    var timeValue:(Int,Int)!
    
    @IBAction func timeChangeHandler(_ sender: UIDatePicker) {
        let formatter = DateFormatter(); formatter.dateFormat = "HH:mm"
        let dateString = formatter.string(from: sender.date)
        let hour = Int(dateString.split(separator: ":")[0])!
        let minute = Int(dateString.split(separator: ":")[1])!
        self.timeValue = (hour,minute)
    }
    
    @IBAction func confirmButtonHandler(_ sender: UIBarButtonItem) {
        self.alarmItem = AlarmItem(timeValue)!
        performSegue(withIdentifier: "unwindToSetUpAlarmVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let originVC = segue.destination as! SetUpAlarmViewController
        originVC.alarmItem = self.alarmItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeValue = alarmItem.timeToWakeUp
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
