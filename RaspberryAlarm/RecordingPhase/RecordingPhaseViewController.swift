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
    @IBOutlet weak var currentTimeLB: UILabel!
    @IBOutlet weak var remainingTimeLB: UILabel!
    
    @IBAction func cancelButtonHandler(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func unwindToRecordingPhase(segue:UIStoryboardSegue) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        phase = Phase.recordingSleep
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let dateFormatter = DateFormatter()
            let today = Date()
            dateFormatter.dateFormat = "HH:mm:ss"
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
            if self.phase == Phase.snooze {
                wakeUpTime += nearestAlarm.snoozeAmount
            }

            let currentDay = Calendar.current.component(.weekday, from: today)
            let currentHour = Int(currentTimeString.split(separator: ":")[0])!
            let currentMinute = Int(currentTimeString.split(separator: ":")[1])!
            let currentSecond = Int(currentTimeString.split(separator: ":")[2])!
            let currentTime = currentHour*60 + currentMinute
            
            if wakeUpTime < currentTime{
                wakeUpTime += 24*60
            }
            
            var remainingTime = 0
            if nearestAlarm.repeatDays.contains(Day(rawValue: currentDay)!){
                remainingTime = wakeUpTime - currentTime
            }else{
                remainingTime = (24*60 - currentTime) + wakeUpTime
            }
            let remainingHour = Int(remainingTime/60)
            let remainingMinute = remainingTime%60 - 1
            let remainingSecond = 60 - currentSecond
            self.remainingTimeLB.text = "\(remainingHour):\(remainingMinute):\(remainingSecond)"
            
            if remainingTime == 0 {
                self.performSegue(withIdentifier: "showRingingPhase", sender: nearestAlarm.snoozeAmount)
                timer.invalidate()
            }
        }
        timer.fire()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let snoozeAmount = sender as? Int else {
            return
        }
        let nextVC = segue.destination as! RingingPhaseViewController
        nextVC.snoozeAmount = snoozeAmount
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
