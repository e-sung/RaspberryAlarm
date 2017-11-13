//
//  RecordingPhaseViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 12..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class RecordingPhaseViewController: UIViewController {

    
    @IBOutlet weak var currentTimeLB: UILabel!
    @IBOutlet weak var remainingTimeLB: UILabel!
    
    @IBAction func cancelButtonHandler(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let remainingMinute = remainingTime%60
            let remainingSecond = 59 - currentSecond
            self.remainingTimeLB.text = "\(remainingHour):\(remainingMinute):\(remainingSecond)"
        }
        timer.fire()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
