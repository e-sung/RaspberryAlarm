//
//  AppDelegate.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

/**
 # OverView

 ## 1. AlarmListViewController
    - 가장 먼저 보는 화면
    - 알람들의 리스트를 보여줌
    - 오른쪽 상단 "+" 버튼으로 새로운 알람 추가
    - 오른쪽 하단 "달모양" 버튼으로 "가장 가까운 알람" 실행(i.e RecordingPhaseViewController실행
    - 각각의 알람아이템을 클릭하면 SetUpAlarmNavViewController로 넘어감. 이 때 segue를 통해 현 아이템의 index.item을 전달함.
 
 ## 2. SetUpAlarmViewController
    - 최초화면에서 각 알람아이템을 클릭하면 들어오는 화면
    - 현재 셋팅 대상이 되는 알람아이템을 가지고 있음
    - WakeUpTimeSetupViewController하고는 segue를 통해 alarmItem.timeToWakeUp 만 주고받고
    - RepeatDaysSetUpViewController와는 segue를 통해 alarmItem.repeatDays만을 주고받음
 
 ## 3. RecordingPhaseViewController
    - DataCenter.main.nearestAlarm 이 계산해준, 가장 가까운 알람이 울릴 때 까지의 카운트다운을 보여줌
    - 몸이 뒤척일 때마다, 뒤척임에 반응하여 수면그래프를 그려줌
    - 수면그래프 기능은, CPU점유율을 너무 높이기 때문에, 현재 experiment 브랜치에만 사용가능
    - alarmItem.timeToHeat 이 되면, 라즈베리파이에 HTTP 리퀘스트 발사(전기장판 켜기)
    - alarmItem.timeToWakeUp 이 되면, RingingPhaseViewController 로 넘어감
 
 ## 4. RingingPhaseViewCOntroller
    - 알람을 울림
    - 스누즈 버튼을 누르면, 다시 RecordingPhase로 가서, alarmItem.snoozeAmount만큼 카운트다운 실시
    - 종료버튼을 누르면 다시한번 라즈베리파이에 HTTP리퀘스트 발사(전기장판 끄기) 하고 AlarmListViewController로 복귀
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

}

