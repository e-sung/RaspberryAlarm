//
//  DataCenter.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import Foundation

/**
 초기화면에 표시해야 할 모든 '알람'아이템들의 객체를 가지고 있는 클래스
 싱글턴 패턴 활용
*/
class DataCenter{
    /// 싱글턴 객체
    static var main:DataCenter = DataCenter()
    /// 어차피 대부분의 사람은 6시30분에 일어나니까, 기본값으로 6시 30분을 주었음
    let defaultAlarm = AlarmItem(on: AlarmTime(hour: 6, minute: 30, second: 0))
    /// 초기화면에 표시되어야 할 모든 알람들의 배열
    var alarmItems:[AlarmItem] = []
    /**
    초기화면 우측하단의 초승달을 눌렀을 때, 실행되어야 할 알람
    1. 오늘의 알람들을 시간순으로 정렬하고,
    2. 가장 빨리 울릴 알람들부터 "현재시간"과 비교해서
    3. 현재시간보다 늦게 울린다면, 그 알람을 리턴
    4. 오늘의 알람 모두가 "현재시간"보다 빨리 울린다면
    5. 내일 가장 먼저 울릴 알람을 리턴
    6. 내일 울릴 알람이 아예 없다면
    7. nil을 리턴
    */
    var nearestAlarm:AlarmItem?{
        get{
            let today = Day(rawValue:Calendar.current.component(.weekday, from: Date()))!
            let tomorrow = Day(rawValue:Calendar.current.component(.weekday, from:
                Date(timeInterval: 24*60*60, since: Date())))!

            for item in AlarmItem.availableAlarms(on: today, given: alarmItems){
                if item.timeToWakeUp.absoluteSeconds > Timer.currentAbsoluteSecond{
                    return item
                }
            }
            let alarmsOfTomorrow = AlarmItem.availableAlarms(on: tomorrow, given: alarmItems)
            if alarmsOfTomorrow.count > 0 {
                return alarmsOfTomorrow[0]
            }else{
                return nil
            }
        }
    }
    
}

extension Timer{
    static var currentAbsoluteSecond:Int{
        get{
            let currentHour = Calendar.current.component(.hour, from: Date())
            let currentMinute = Calendar.current.component(.minute, from: Date())
            let currentSecond = Calendar.current.component(.second, from: Date())
            return currentHour*60*60 + currentMinute*60 + currentSecond
        }
    }
}
