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
    var alarmTimer:Timer!
    /// 풀잠중인지 쪽잠중인지의 여부
    var currentPhase:Phase!
    /// 쪽잠 잘 시간이 얼마나 남았는지 : 쪽잠 Phase 때, 1초마다 줄어듬
    var remainingSnoozeAmount:Int = 0
    /// 일어날 때 까지 몇 초 남았는지
    var wakeUpTimeInSeconds:Int!

    // MARK: 수면그래프 작성을 위한, 가속도 센서 관련 전역변수들
    /// 가속도 센서 확인할 주기 (단위 :Hz)
    let motionSensingRate = 10.0
    ///  motionSensingRate 마다 불리는 타이머
    var motionSensorTimer:Timer!
    /// motion을 할 sensing 할 객체
    let motionManager:CMMotionManager = CMMotionManager()
    /// 그래프를 새로 그릴 주기 (단위 :초)
    let chartRefreshRate = 1
    /// 핸드폰이 흔들렸는지 확인할 기준치 : `func startAccelerometers()`참고
    var lastState = 0
    /// 1초동안 핸드폰이 흔들린 횟수 (sleep movements in seconds)
    var smInSeconds = 0
    /// 이 데이터를 바탕으로 수면그래프를 그림
    var sleepData:[Float] = [0.0]
    
    // MARK: IBOutlets
    /// 현재 시간을 표시할 UILabel
    @IBOutlet weak var currentTimeLB: UILabel!
    /// 일어날 때 까지 남은 시간을 표시할 UILabel
    @IBOutlet weak var remainingTimeLB: UILabel!
    /// 뒤척임 기록을 보여주는 차트
    @IBOutlet weak var chart: Chart!
    
    // MARK: IBActions
    /// 수면기록을 중단하고, 이전 화면으로 돌아가는 버튼
    @IBAction func cancelButtonHandler(_ sender: UIButton) {
        alarmTimer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    /// 실제로 하는 일은 없음. 다른 화면에서 이곳으로 돌아오기 위한 등대의 역할
    @IBAction func unwindToRecordingPhase(segue:UIStoryboardSegue) {
    }
    
    // MARK: 생명주기
    /// 하는 일 : 각종 속성 초기화 실시
    override func viewDidLoad() {
        super.viewDidLoad()
        //startAccelerometers()
    }
    /**
     하는 일
     1. 핸드폰 꺼지는 것 방지
     2. alarmTimer 실행
     */
    override func viewWillAppear(_ animated: Bool) {
        guard let alarm = DataCenter.main.nearestAlarm else {alert(msg:"설정된 알람이 없습니다!");return}
        self.alarmItem = alarm
        self.remainingSnoozeAmount = alarm.snoozeAmount
        self.currentPhase = .recordingSleep
        if Timer.currentSecondsOfToday > self.alarmItem.wakeUpTimeInSeconds { //오늘 자고 내일 일어나는 경우
            self.wakeUpTimeInSeconds =  alarmItem.wakeUpTimeInSeconds + 24*60*60
        }else{
            self.wakeUpTimeInSeconds = alarmItem.wakeUpTimeInSeconds //오늘 자고 오늘 일어나는 경우
        }
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
     1. 남은 시간 계산 및 현재 시간 표시
        * 풀잠 Phase냐, 쪽잠 Phase냐에 따라 remainingTime의 계산방식이 달라짐
     2. 매 chartRefreshRate초 마다 그래프 새로 그리기
     3. 알람 켤 시간/ 전기장판 킬 시간에 알람도 키고 전기장판도 키기.
     */
    func generateAlarmTimer()->Timer{
        return Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.currentTimeLB.text = Timer.currentHHmmss // 화면에 현재시간을 HH:mm:ss 로 표시
           
            //남은시간 계산
            var remainingTime = 0
            if self.currentPhase == .recordingSleep { //풀잠 자는 경우, 남은 시간
                remainingTime = self.wakeUpTimeInSeconds - Timer.currentSecondsOfToday
            }else{ // 쪽잠 자는 경우, 남은 시간
                remainingTime = self.remainingSnoozeAmount
                self.remainingSnoozeAmount -= 1
            }
            self.remainingTimeLB.text = self.generateHHmmssOutOf(remainingTime)
            
            // 그래프 새로 그리기
//            if remainingTime%self.chartRefreshRate == 0 {
//                self.reDrawChart() //차트를 새로 그리고
//                self.smInSeconds = 0 //smInSeconds(SleepMovementsInSeconds) 를 초기화
//            }

            if remainingTime == self.alarmItem.timeToHeat{ //전기장판 켜기
                URLSession.shared.dataTask(with: URL(string: "http://192.168.0.20:3030")!).resume()
            }
            if remainingTime == 0{//알람 울리기
                timer.invalidate()
                self.performSegue(withIdentifier: "showRingingPhase", sender: self.alarmItem.snoozeAmount)
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
    func startAccelerometers() {
        // Make su복re the accelerometer hardware is available.
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
    /**
     UIAlertController 를 쉽게 쓰게 만드는 함수.
     - ToDo : 더 쓰일 곳이 생기면, 파일 하나 새로 만들자.
     */
    func alert(msg:String){
        let alert = UIAlertController(title: "안내", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel , handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     초단위의 시간을 넣으면 "HH:mm:ss" 형식의 문자열 반환
     - Remark:
     Date랑 DateFormatter로 더 똑똑하게 처리할 방법이 있을 것인데...
     */
    func generateHHmmssOutOf(_ seconds:Int)->String{
        let outputHour = Int(seconds/3600)
        let outputMinute = Int((seconds - outputHour*3600)/60)
        let outputSecond = seconds - outputHour*3600 - outputMinute*60
        return "\(outputHour):\(outputMinute):\(outputSecond)"
    }
    
    /**
    그래프 갱신하는 함수
     사실 실제로 하는 일은 Chart객체에 새 데이터를 집어넣는 것 뿐.
     - ToDo:
     chart객체가 실제로 어떻게 View를 업데이트하는지 알아봐야겠다.
     */
    func reDrawChart(){
        self.sleepData.append(Float(self.smInSeconds))
        self.chart.add(ChartSeries(self.sleepData))
    }
}

extension Timer{
    /**
     현재 시간을 HH:mm:ss 모양의 문자열로 바꿔주는 계산속성
     
     - Remark:
     사실 구현한 내용을 그냥 매번 코드에 써도 되는데,
     별 것도 아닌게 2줄이나 차지하는게 마음에 안들어서 만들었음
     */
    static var currentHHmmss:String{
        get{
            let dateFormatter = DateFormatter(); dateFormatter.dateFormat = "HH:mm:ss"
            return dateFormatter.string(from: Date())
        }
    }
    
    /**
    오늘 0시0분0초부터 현시점까지 누적된 초
     - ToDo:
     분명히 이거보다 똑똑한 방법이 있을 것이라고 봄.
     */
    static var currentSecondsOfToday:Int{
        let currentTimeString = Timer.currentHHmmss
        let currentHour = Int(currentTimeString.split(separator: ":")[0])!
        let currentMinute = Int(currentTimeString.split(separator: ":")[1])!
        let currentSecond = Int(currentTimeString.split(separator: ":")[2])!
        return currentHour*60*60 + currentMinute*60 + currentSecond
    }
}
