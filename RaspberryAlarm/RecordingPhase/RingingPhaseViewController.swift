//
//  RingingPhaseViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 13..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class RingingPhaseViewController: UIViewController {

    var snoozeAmount:Int!
    
    @IBAction func snoozeButtonHandler(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToRecordingPhase", sender: Phase.snooze)
    }
    
    @IBAction func terminateButtonHandler(_ sender: UIButton) {
//        let alarmTerminationNoti = Notification(name: .init("AlarmTerminated"))
        self.performSegue(withIdentifier: "unwindToAlarmList", sender: nil)
//        NotificationCenter.default.post(alarmTerminationNoti)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? RecordingPhaseViewController {
            nextVC.phase = sender as! Phase
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let recorderTerminatedNoti = Notification(name: .init("RecorderTerminated"))
//        NotificationCenter.default.addObserver(forName: recorderTerminatedNoti.name , object: nil, queue: nil) { (noti) in
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
