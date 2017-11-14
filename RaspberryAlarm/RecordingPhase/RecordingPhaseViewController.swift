//
//  RecordingPhaseViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 12..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit
import CoreMotion
class RecordingPhaseViewController: UIViewController {
    
    // TODO : Record Sleep Phase With HealthKit
    var phase:Phase!
    var alarmTimer:Timer!
    var motionSensorTimer:Timer!
    let motion:CMMotionManager = CMMotionManager()
    @IBOutlet weak var currentTimeLB: UILabel!
    @IBOutlet weak var remainingTimeLB: UILabel!
    
    @IBAction func cancelButtonHandler(_ sender: UIButton) {
        alarmTimer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func unwindToRecordingPhase(segue:UIStoryboardSegue) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        phase = Phase.recordingSleep
        setupTimer()
        alarmTimer.fire()
        startAccelerometers()
    }
    override func viewWillAppear(_ animated: Bool) {
        if !alarmTimer.isValid && self.phase == Phase.snooze {
            setupTimer()
            alarmTimer.fire()
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
        alarmTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
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
            
            print(remainingTime, remainingSecond, nearestAlarm.timeToHeat)
            
            if remainingTime == nearestAlarm.timeToHeat && remainingSecond == 1{
                let url = URL(string: "http://192.168.0.20:3030")!
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                }.resume()
            }else if remainingTime == 1 && remainingSecond == 1 {
                timer.invalidate()
                self.performSegue(withIdentifier: "showRingingPhase", sender: nearestAlarm.snoozeAmount)
            }
        }
    }
    
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isAccelerometerAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
            
            // Configure a timer to fetch the data.
            self.motionSensorTimer = Timer(fire: Date(), interval: (1.0/60.0), repeats: true, block: { (timer) in
                // Get the accelerometer data.
                if let data = self.motion.accelerometerData {
                    let x = data.acceleration.x
                    let y = data.acceleration.y
                    let z = data.acceleration.z
                    print(x,y,z)
                }
            })
            // Add the timer to the current run loop.
            RunLoop.current.add(self.motionSensorTimer!, forMode: .defaultRunLoopMode)
        }
    }

}
