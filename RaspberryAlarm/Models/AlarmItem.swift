//
//  AlarmItem.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import Foundation

/**
알람을 울리는데 필요한 정보들
 1. 몇 시에 울릴지
 2. 무슨 요일에 울릴지
 3. 전기장판은 언제 켤지
 4. Snooze는 얼마나 할지
 */

typealias Second = Int
struct AlarmItem {
    /// 일어날 시간 : (단위 : 초/ 기준: 00시00분00초)
    var timeToWakeUp:AlarmTime
    /// 전기장판 킬 시간(단위 : 초)
    var timeToHeat:Second = 30*60
    /// 활성화 여부 : 메인화면에서, 스위치를 토글함으로써 변경.
    /// - ToDo : 사실 스위치 토글은 아직 구현 안 됬음
    var isActive:Bool = true
    /// 스누즈 할 양(단위: 초)
    var snoozeAmount:Second = 15*60
    /// 이 알람이 울려야 할 날들 : [월,화,수,목,금,토,일] 중 복수선택
    /// - ToDo : 생각해보니 더 적절한 변수명이 있을 것 같다.
    var repeatDays:[Day] = [.Mon,.Tue,.Wed,.Thu,.Fri]
    
    init(on time:AlarmTime) {
        self.timeToWakeUp = time
    }
}
