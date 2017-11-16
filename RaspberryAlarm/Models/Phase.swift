//
//  Phase.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 13..
//  Copyright © 2017년 류성두. All rights reserved.
//

import Foundation

/**
 현재 유저가 뭐하는 중인지
 - Note :
 같은 화면이라고 해도, 그 전에 뭘 했느냐에 따라 취해야 할 행동이 다를 수 있음
 */
enum Phase{
    /// [AlarmListViewController]() 참조
    case alarmList
    /// [SetUpAlarmViewController]() 참조
    case alarmSetting
    /// [WakeUpTimeSecondsController](), [RepeatDaysSetUpController]() 등 참조
    case alarmSettingSpecific
    /// 풀잠국면 : [AlarmListViewController]() -> [RecordingPhaseViewController]()인 상황
    case recordingSleep
    /// 쪽잠국면 : [RingingPhaseViewController]() -> [RecordingPhaseViewController]()인 상황
    case snooze
}
