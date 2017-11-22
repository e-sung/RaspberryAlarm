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
/** # 무엇을 하는 놈인가?
 1. 현재시간과 기상까지 남은 시간을 표시:
 2. 가속도 센서 감지/그래프 작성:

 - ToDo: HealthKit에 수면데이터 저장하기
*/
class RecordingPhaseViewController: UIViewController {
    
    // MARK: 알람이 울릴 시간을 계산하는데 사용할 전역변수들
    /// 현재시간과 남은 시간 계산을 위해 1초마다 불리는 타이머
    private var alarmTimer:Timer!
    /// 일어나야 할 시간
    private var timeToWakeUp:TimeInterval!
    /// 아침에 전기장판 켤 시간
    private var timeToHeatBeforeAwake:TimeInterval!
    /// 저녁에 전기장판 끌 시간
    private var timeToHeatAfterAsleep:TimeInterval!
    /// Snooze 할 시간
    private var timeToSnooze:TimeInterval!
    /// 초를 HH:mm:ss 형식의 문자열로 바꿔줄 포매터
    private var dateFormatter:DateFormatter!
    /// 일어날 때 까지 남은 시간
    private var remainingTime:TimeInterval{
        get{
            return self.timeToWakeUp - Date().absoluteSeconds
        }
    }
    
    // MARK: 전기장판 URL
    private var turnOnUrl:URL!
    private var turnOffURL:URL!

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
    /// RingingPhase에서 이곳으로 넘어왔다는 것은, Snooze를 눌렀다는 뜻!
    @IBAction func unwindToRecordingPhase(segue:UIStoryboardSegue) {
        if let _ = segue.source as? RingingPhaseViewController{
            self.timeToWakeUp = Date().absoluteSeconds + self.timeToSnooze
        }
    }
    
    // MARK: 생명주기
    /// 하는 일 : 각종 속성 초기화 실시
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTimes()
        self.initURLs()
        self.dateFormatter = DateFormatter()
    }
    
    private func initTimes(){
        self.timeToWakeUp = (TimeInterval(UserDefaults.standard.integer(forKey: wakeUpHourKey)*3600 +
                                          UserDefaults.standard.integer(forKey: wakeUpMinuteKey)*60))
        self.timeToWakeUp = reflectAmPm(on: self.timeToWakeUp)
        self.timeToWakeUp = sanitize(self.timeToWakeUp)
        self.timeToSnooze = UserDefaults.standard.double(forKey: timeToSnoozeKey)
        self.timeToHeatAfterAsleep = UserDefaults.standard.double(forKey: timeToHeatAfterAleepKey)
        self.timeToHeatBeforeAwake = UserDefaults.standard.double(forKey: timeToHeatBeforeAwakeKey)
    }
    
    private func initURLs(){
        self.turnOnUrl = UserDefaults.standard.url(forKey: URLsKeys[1])!
        self.turnOffURL = UserDefaults.standard.url(forKey: URLsKeys[2])!
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
        //startAccelerometers()
    }
    /// 하는 일 : 다시 핸드폰이 꺼질 수 있는 상태로 복귀시킴
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false //다시 핸드폰 꺼질 수 있는 상태로 복귀
        motionManager.stopAccelerometerUpdates()
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
            self.currentTimeLB.text = self.dateFormatter.format(seconds: Date().absoluteSeconds, with: DateFormatter.mainDateFormat)
            self.remainingTimeLB.text = self.dateFormatter.format(seconds: self.remainingTime, with: DateFormatter.mainDateFormat)

//            // 그래프 새로 그리기
//            if Int(self.remainingTime) % self.chartRefreshRate == 0 {
//                self.reDrawChart() //차트를 새로 그리고
//                self.smInSeconds = 0 //smInSeconds(SleepMovementsInSeconds) 를 초기화
//            }
            
            //잠든 뒤 timeToHeatAfterAsleep 뒤에 전기장판 끄기
            self.timeToHeatAfterAsleep = self.timeToHeatAfterAsleep - 1.0
            if Int(self.timeToHeatAfterAsleep) == 0 {
                URLSession.shared.dataTask(with: self.turnOffURL).resume()
            }

            //기상시간으로부터 timeToHeatBeforeAwake 전에 전기장판 켜기
            if Int(self.remainingTime) == Int(self.timeToHeatBeforeAwake){
                URLSession.shared.dataTask(with: self.turnOnUrl).resume()
            }
            
            //알람 울리기
            if Int(self.remainingTime) == 0{
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
    /// 오전/오후 반영
    private func reflectAmPm(on time:TimeInterval)->TimeInterval{
        var isAm:Bool = true
        if UserDefaults.standard.object(forKey: ampmKey) != nil {
            isAm = UserDefaults.standard.integer(forKey: ampmKey) == 0 ? true : false
        }
        return isAm ? time : time + 12.0*3600.0
    }
    
    /// 오늘자고 내일일어나는 경우와, 오늘 자고 오늘 일어나는 경우 반영
    private func sanitize(_ wakeUpSeconds:TimeInterval)->TimeInterval{
        if Date().absoluteSeconds > wakeUpSeconds{
            return wakeUpSeconds + TimeInterval(24*60*60) //오늘 자고 내일 일어나는 경우
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
