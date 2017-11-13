//
//  RecordingPhaseViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 12..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class RecordingPhaseViewController: UIViewController {
    
    
    var phase:Phase!
    var timer:Timer!
    @IBOutlet weak var currentTimeLB: UILabel!
    @IBOutlet weak var remainingTimeLB: UILabel!
    
    @IBAction func cancelButtonHandler(_ sender: UIButton) {
        timer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func unwindToRecordingPhase(segue:UIStoryboardSegue) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        phase = Phase.recordingSleep
//        let alarmTerminationNoti = Notification(name: .init("AlarmTerminated"))
//        NotificationCenter.default.addObserver(forName: alarmTerminationNoti.name , object: nil, queue: nil) { (noti) in
//            print("Broadcast recieved")
//            self.dismiss(animated: false, completion: {
//                let recorderTerminatedNoti = Notification(name: .init("RecorderTerminated"))
//                NotificationCenter.default.post(recorderTerminatedNoti)
//            })
//        }
        setupTimer()
        timer.fire()
    }
    override func viewWillAppear(_ animated: Bool) {
        if !timer.isValid && self.phase == Phase.snooze {
            setupTimer()
            timer.fire()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let snoozeAmount = sender as? Int else {
            return
        }
        let nextVC = segue.destination as! RingingPhaseViewController
        nextVC.snoozeAmount = snoozeAmount
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if self.phase == Phase.alarmList {
            return false
        }else{
            return true
        }
    }
    
    func setupTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let dateFormatter = DateFormatter(); dateFormatter.dateFormat = "HH:mm:ss"
            let today = Date()
            let currentTimeString = dateFormatter.string(from: today)
            self.currentTimeLB.text = currentTimeString
            
            guard let nearestAlarm = DataCenter.main.nearestAlarm else {
                let alert = UIAlertController(title: "안내", message: "설정된 알람이 없습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel , handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let wakeUpHour = nearestAlarm.timeToWakeUp.0
            let wakeUpMinute = nearestAlarm.timeToWakeUp.1
            var wakeUpTime = wakeUpHour*60 + wakeUpMinute

            let currentDay = Calendar.current.component(.weekday, from: today)
            let currentHour = Int(currentTimeString.split(separator: ":")[0])!
            let currentMinute = Int(currentTimeString.split(separator: ":")[1])!
            let currentSecond = Int(currentTimeString.split(separator: ":")[2])!
            let currentTime = currentHour*60 + currentMinute
            
            if wakeUpTime < currentTime{
                wakeUpTime += 24*60
            }
            
            var remainingTime = Int.max
            if self.phase == Phase.snooze {
                remainingTime = nearestAlarm.snoozeAmount
            }else if nearestAlarm.repeatDays.contains(Day(rawValue: currentDay)!){
                remainingTime = wakeUpTime - currentTime
            }else{
                remainingTime = (24*60 - currentTime) + wakeUpTime
            }
            let remainingHour = Int(remainingTime/60)
            let remainingMinute = remainingTime%60 - 1
            let remainingSecond = 60 - currentSecond
            self.remainingTimeLB.text = "\(remainingHour):\(remainingMinute):\(remainingSecond)"
            
            print(remainingTime, remainingSecond)
            if remainingTime == 1 && remainingSecond == 1 {
                timer.invalidate()
                self.performSegue(withIdentifier: "showRingingPhase", sender: nearestAlarm.snoozeAmount)
            }
        }
    }
    
}
