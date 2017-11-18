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
 # OverView
 ## 1. 무엇을 하는 놈인가?
 크게 두 가지 일을 합니다.
 1. 현재시간과 기상시간을 표시:
 2. 가속도 센서 감지/그래프 작성:

 ## 2. 그것을 어떻게 하는가?
 1. 기상시간 계산 : `func generateAlarmTimer()` 참고
    1. 가장 근시일에 울려야 할 알람은, DataCenter.main 의 계산속성을 통해서 알 수 있음.
    2. 근데 이 알람이 울릴 시간이 현재시각보다 과거면(!), 내일 울릴 알람이라고 판단함.
    3. 앱을 켜두고 잠드는 상황을 상정했기에, "내일 모레" 알람이 울리는 것은 상정하지 않음.
 2. 그래프 작성 : `func startAccelerometers()`참고
 
 - ToDo: HealthKit에 수면데이터 저장하기
*/
class RecordingPhaseViewController: UIViewController {
    
    // MARK: 알람이 울릴 시간을 계산하는데 사용할 전역변수들
    /// [AlarmItem](http://blog.e-sung.net/) 참조
    var alarmItem:AlarmItem!
    /// 현재시간과 남은 시간 계산을 위해 1초마다 불리는 타이머
    private var alarmTimer:Timer!
    /// 일어나야 할 시간(단위: 초)
    private var wakeUpTimeInSeconds:Int!
    /// 일어날 때 까지 남은 시간(단위: 초)
    private var remainingTimeInSeconds:Int{
        get{
            return self.wakeUpTimeInSeconds - Date().absoluteSeconds
        }
    }

    // MARK: 수면그래프 작성을 위한, 가속도 센서 관련 전역변수들
    /// 가속도 센서 확인할 주기 (단위 :Hz)
    private let motionSensingRate = 10.0
    ///  motionSensingRate 마다 불리는 타이머
    private var motionSensorTimer:Timer!
    /// motion을 할 sensing 할 객체
    private let motionManager:CMMotionManager = CMMotionManager()
    /// 그래프를 새로 그릴 주기 (단위 :초)
    private let chartRefreshRate = 1
    /// 핸드폰이 흔들렸는지 확인할 기준치 : `func startAccelerometers()`참고
    private var lastState = 0
    /// 1초동안 핸드폰이 흔들린 횟수 (sleep movements in seconds)
    private var smInSeconds = 0
    /// 이 데이터를 바탕으로 수면그래프를 그림
    private var sleepData:[Float] = [0.0]
    
    // MARK: IBOutlets
    /// 현재 시간을 표시할 UILabel
    @IBOutlet private weak var currentTimeLB: UILabel!
    /// 일어날 때 까지 남은 시간을 표시할 UILabel
    @IBOutlet private weak var remainingTimeLB: UILabel!
    /// 뒤척임 기록을 보여주는 차트
    @IBOutlet private weak var chart: Chart!
    
    // MARK: IBActions
    /// 수면기록을 중단하고, 이전 화면으로 돌아가는 버튼
    @IBAction private func cancelButtonHandler(_ sender: UIButton) {
        alarmTimer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    /// 실제로 하는 일은 없음. 다른 화면에서 이곳으로 돌아오기 위한 등대의 역할
    @IBAction func unwindToRecordingPhase(segue:UIStoryboardSegue) {
        self.wakeUpTimeInSeconds = Date().absoluteSeconds + self.alarmItem.snoozeAmount
    }
    
    // MARK: 생명주기
    /// 하는 일 : 각종 속성 초기화 실시
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wakeUpTimeInSeconds = clarify(alarmItem.timeToWakeUp.absoluteSeconds)
    }
    
    /**
     하는 일
     1. 핸드폰 꺼지는 것 방지
     2. alarmTimer 실행
     */
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = true //핸드폰 꺼지는 것 방지
        alarmTimer = generateAlarmTimer()
        alarmTimer.fire()
    }
    /// 하는 일 : 다시 핸드폰이 꺼질 수 있는 상태로 복귀시킴
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false //다시 핸드폰 꺼질 수 있는 상태로 복귀
    }
    
    // MARK: 매 1초마다 해야 할 일 aka 시간계산 및 표시
    /**
    매 초마다 해야 할 일들을 정의
     
     - Remark: 하는 일 목록
     1. 시간 표시
     2. 매 chartRefreshRate초 마다 그래프 새로 그리기
     3. 알람 켤 시간/ 전기장판 킬 시간에 알람도 키고 전기장판도 키기.
     */
    private func generateAlarmTimer()->Timer{
        return Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            // 시간 표시
            self.currentTimeLB.text = Date.format(seconds: Date().absoluteSeconds, with: Date.mainDateFormat)
            self.remainingTimeLB.text = Date.format(seconds: self.remainingTimeInSeconds, with: Date.mainDateFormat)

            // 그래프 새로 그리기
//            if remainingTime%self.chartRefreshRate == 0 {
//                self.reDrawChart() //차트를 새로 그리고
//                self.smInSeconds = 0 //smInSeconds(SleepMovementsInSeconds) 를 초기화
//            }

            //전기장판 켜기
            if self.remainingTimeInSeconds == self.alarmItem.timeToHeat{
                URLSession.shared.dataTask(with: URL(string: "http://192.168.0.20:3030")!).resume()
            }
            
            //알람 울리기
            if self.remainingTimeInSeconds == 0{
                timer.invalidate()
                self.performSegue(withIdentifier: "showRingingPhase", sender: self)
            }
        }
    }
    
    // MARK: 매 1/10초마다 해야 할 일 aka 가속도센서감지
    /**
     가속도 센서를 통해, 뒤척임을 감지합니다.
     
     1. 현시점의 핸드폰 상태 = x축값 + y축값 + z축값
     2. 이 값을 "과거의 핸드폰 상태"와 비교
     3. 비교 결과, 핸드폰이 움직였다고 한다면, 움직임을 smInSeconds(SleepMotionInSeconds)에 기록
     4. 현시점의 핸드폰상태를 "과거의 핸드폰 상태" 변수에 저장.
     5. 반복
     */
    private func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motionManager.isAccelerometerAvailable {
            self.motionManager.accelerometerUpdateInterval = 1.0 / self.motionSensingRate
            self.motionManager.startAccelerometerUpdates()

            // Configure a timer to fetch the data.
            self.motionSensorTimer = Timer(fire: Date(), interval: (1.0/self.motionSensingRate), repeats: true,
                block: { (timer) in
                // Get the accelerometer data.
                if let data = self.motionManager.accelerometerData {
                    let x = data.acceleration.x;let y = data.acceleration.y;let z = data.acceleration.z
                    let currentState = Int(abs((x + y + z)*10)) // 왜 저는 정수가 아니면 뭔가 안심이 안 되는 걸까요...
                    if (currentState - self.lastState) != 0 {
                        self.smInSeconds += 1
                    }
                    self.lastState = currentState
                }
            })
            RunLoop.current.add(self.motionSensorTimer!, forMode: .defaultRunLoopMode)
        }
    }
    

    // MARK: 편의상 만든 함수들
    private func clarify(_ wakeUpSeconds:Int)->Int{
        if Date().absoluteSeconds > wakeUpSeconds{
            return wakeUpSeconds + 24*60*60 //오늘 자고 내일 일어나는 경우
        }else{
            return wakeUpSeconds //오늘 자고 오늘 일어나는 경우
        }
    }
    

    /**
    그래프 갱신하는 함수
     사실 실제로 하는 일은 Chart객체에 새 데이터를 집어넣는 것 뿐.
     - ToDo:
     chart객체가 실제로 어떻게 View를 업데이트하는지 알아봐야겠다.
     */
    private func reDrawChart(){
        self.sleepData.append(Float(self.smInSeconds))
        self.chart.add(ChartSeries(self.sleepData))
    }
}


