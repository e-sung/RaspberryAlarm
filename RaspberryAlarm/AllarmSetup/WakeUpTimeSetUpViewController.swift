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
    private var timeValue:(Int,Int) = (6,30)
    
    @IBAction func timeChangeHandler(_ sender: UIDatePicker) {
        self.timeValue = generateTime(outof: sender.date)
    }
    
    @IBAction func confirmButtonHandler(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToSetUpAlarmVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SetUpAlarmViewController
        nextVC.alarmItem.timeToWakeUp = self.timeValue
    }
    
    /**
     튜플 형태의 '시간'객체 생성 : (Hour,minute)
     - Parameter date : DatePicker에서 선택된 시간이 들어가야 함
     */
    func generateTime(outof date:Date)->(Int,Int){
        let formatter = DateFormatter(); formatter.dateFormat = "HH:mm"
        let dateString = formatter.string(from: date)
        
        let hour = Int(dateString.split(separator: ":")[0])!
        let minute = Int(dateString.split(separator: ":")[1])!
        return (hour,minute)
    }
}
