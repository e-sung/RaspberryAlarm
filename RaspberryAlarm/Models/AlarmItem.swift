//
//  AlarmItem.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import Foundation

/**
Object that has every info to make an Alarm
 

 - timeToHeat : on scale of Minute. Http Request will be fired on (timeToWakeUP - heatAmount)
 - snoozeAmount : on scale of Minute. Should be initialized in range of 0..<60
 - daysToRepeat : Mon/Tue/Wed/Thu/Fri/Sat/Sun
*/
struct AlarmItem {
    /// 일어날 시간 : (Hour, Minute)
    var timeToWakeUp:(Int,Int)
    /// 전기장판 킬 시간(단위 : 초)
    var timeToHeat:Int = 30*60
    /// 유효여부 : 메인화면에서, 스위치를 토글함으로써 변경.
    /// - ToDo : 사실 스위치 토글은 아직 구현 안 됬음
    var isActive:Bool = true
    /// 스누즈 할 양(단위: 초)
    var snoozeAmount:Int = 15*60
    /// 이 알람이 울려야 할 날들 : [월,화,수,목,금,토,일] 중 복수선택
    /// - ToDo : 생각해보니 더 적절한 변수명이 있을 것 같다.
    var repeatDays:[Day] = [.Mon,.Tue,.Wed,.Thu,.Fri]
    /// 일어날 시간을 초로 환산.
    /// - ToDo : 생각해보니 처음부터 일어날 시간을 초로 다뤘으면 되는 거였는데, 너무 멀리왔다.
    /// 급한거 고치고 나중에 한 번에 리팩토링하자.
    var wakeUpTimeInSeconds:Int{
        get{
            return self.timeToWakeUp.0*3600 + self.timeToWakeUp.1*60
        }
    }
}

//MARK: Initializers
extension AlarmItem{
    
    init?(_ time:(Int,Int)) {
        let hour = time.0; let minute = time.1
        if AlarmItem.validityOfTime(hour, minute) == false {
            return nil
        }else{
            self.timeToWakeUp = time
        }
    }

    init?(_ time:(Int,Int), _ heatAmount:Int, _ snoozeAmount:Int, _ repeatDays:[Day]){
        if AlarmItem.validityOfTime(time.0, time.1) == false{
            return nil
        }else if AlarmItem.validityOfMinute(heatAmount) == false {
            return nil
        }else if AlarmItem.validityOfMinute(snoozeAmount) == false {
            return nil
        }
        self.timeToWakeUp = time
        self.timeToHeat = heatAmount
        self.snoozeAmount = snoozeAmount
        self.repeatDays = repeatDays
    }
}

//MARK: Helper Functions
/// 이것들도 처음부터 "일어날 시간"을 "초"로 다뤘으면 필요 없었을 것들. 
extension AlarmItem{
    private static func validityOfTime(_ hour:Int, _ minute:Int)->Bool{
        return validityOfHour(hour) && validityOfMinute(minute)
    }
    
    private static func validityOfHour(_ hour:Int)->Bool{
        return (hour>=0 && hour<24)
    }
    
    private static func validityOfMinute(_ minute:Int)->Bool{
        return (minute>=0 && minute<60)
    }
}
