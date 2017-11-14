//
//  RecordingPhaseViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 12..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit
import CoreMotion
import SwiftChart
/**
 - ToDo: Record Sleep Phase With HealthKit
*/
class RecordingPhaseViewController: UIViewController {
    
    // MARK: 알람이 울릴 시간을 계산하는데 사용할 전역변수들
    var alarmItem:AlarmItem!
    var alarmTimer:Timer! //현재시간과 남은 시간 계산을 위해 1초마다 불리는 타이머
    var currentPhase:Phase! // 풀잠중인지 쪽잠중인지의 여부
    var remainingSnoozeAmount:Int = 0 //쪽잠 잘 시간이 얼마나 남았는지 (쪽잠 Phase 때, 1초마다 줄어듬)
    var sleepData:[Float] = [0.0]
    var wakeUpTimeInSeconds:Int!

    // MARK: 수면그래프 작성을 위한, 가속도 센서 관련 전역변수들
    var motionSensorTimer:Timer! //  1/10 불림
    let motionManager:CMMotionManager = CMMotionManager()
    var lastState = 0 // 핸드폰이 흔들렸는지 확인할 기준점
    var smInSeconds = 0 //1초동안 핸드폰이 흔들린 횟수
    
    // MARK: IBOutlets
    @IBOutlet weak var currentTimeLB: UILabel!
    @IBOutlet weak var remainingTimeLB: UILabel!
    @IBOutlet weak var chart: Chart!
    
    // MARK: IBActions
    @IBAction func cancelButtonHandler(_ sender: UIButton) {
        alarmTimer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func unwindToRecordingPhase(segue:UIStoryboardSegue) {
    }
    
    // MARK: 생명주기
    // 각종 속성 초기화 실시
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let alarm = DataCenter.main.nearestAlarm else {alert(msg:"설정된 알람이 없습니다!"); return}
        self.alarmItem = alarm
        self.remainingSnoozeAmount = alarm.snoozeAmount
        self.currentPhase = Phase.recordingSleep
        if Timer.currentSecondsOfToday > self.alarmItem.wakeUpTimeInSeconds { //오늘 자고 내일 일어나는 경우
            self.wakeUpTimeInSeconds =  alarmItem.wakeUpTimeInSeconds + 24*60*60
        }else{
            self.wakeUpTimeInSeconds = alarmItem.wakeUpTimeInSeconds //오늘 자고 오늘 일어나는 경우
        }
        startAccelerometers()
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = true //핸드폰 꺼지는 것 방지
        alarmTimer = generateAlarmTimer()
        alarmTimer.fire()
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false //다시 핸드폰 꺼질 수 있는 상태로 복귀
    }
    
    // MARK: 매 1초마다 해야 할 일 aka 시간계산 및 표시
    func generateAlarmTimer()->Timer{
        return Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.currentTimeLB.text = Timer.currentHHmmss // 화면에 현재시간을 HH:mm:ss 로 표시
            
            var remainingTime = 0
            if self.currentPhase == .recordingSleep { //풀잠 자는 경우, 남은 시간
                remainingTime = self.wakeUpTimeInSeconds - Timer.currentSecondsOfToday
            }else{ // 쪽잠 자는 경우, 남은 시간
                remainingTime = self.remainingSnoozeAmount
                self.remainingSnoozeAmount -= 1
            }
            self.remainingTimeLB.text = self.generateHHmmssOutOf(remainingTime)
            
            if remainingTime%5 == 0 {
                self.sleepData.append(Float(self.smInSeconds))
                let series = ChartSeries(self.sleepData)
                self.chart.add(series)
                self.smInSeconds = 0
            }

            if remainingTime == self.alarmItem.timeToHeat{
                URLSession.shared.dataTask(with: URL(string: "http://192.168.0.20:3030")!).resume()
            }else if remainingTime == 0{
                timer.invalidate()
                self.performSegue(withIdentifier: "showRingingPhase", sender: self.alarmItem.snoozeAmount)
            }
        }
    }
    
    // MARK: 매 1/10초마다 해야 할 일 aka 가속도센서감지
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motionManager.isAccelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = 1.0 / 10.0  // 10 Hz
            self.motionManager.startAccelerometerUpdates()

            // Configure a timer to fetch the data.
            self.motionSensorTimer = Timer(fire: Date(), interval: (1.0/10.0), repeats: true, block: { (timer) in
                // Get the accelerometer data.
                if let data = self.motionManager.accelerometerData {
                    let x = data.acceleration.x;let y = data.acceleration.y;let z = data.acceleration.z
                    let currentState = Int(abs((x + y + z)*10))

                    if (currentState - self.lastState) != 0 {
                        self.smInSeconds += 1
                    }
                    self.lastState = currentState
                }
            })
            // Add the timer to the current run loop.
            RunLoop.current.add(self.motionSensorTimer!, forMode: .defaultRunLoopMode)
        }
    }
    

    func alert(msg:String){
        let alert = UIAlertController(title: "안내", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel , handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func generateHHmmssOutOf(_ seconds:Int)->String{
        let outputHour = Int(seconds/3600)
        let outputMinute = Int((seconds - outputHour*3600)/60)
        let outputSecond = seconds - outputHour*3600 - outputMinute*60
        return "\(outputHour):\(outputMinute):\(outputSecond)"
    }
}

extension Timer{
    static var currentHHmmss:String{
        get{
            let dateFormatter = DateFormatter(); dateFormatter.dateFormat = "HH:mm:ss"
            return dateFormatter.string(from: Date())
        }
    }
    static var currentSecondsOfToday:Int{
        let currentTimeString = Timer.currentHHmmss
        let currentHour = Int(currentTimeString.split(separator: ":")[0])!
        let currentMinute = Int(currentTimeString.split(separator: ":")[1])!
        let currentSecond = Int(currentTimeString.split(separator: ":")[2])!
        return currentHour*60*60 + currentMinute*60 + currentSecond
    }
}
