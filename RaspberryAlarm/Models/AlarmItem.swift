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
 
 - timeToWakeUp : (Hour, Minute)
 - timeToHeat : on scale of Minute. Http Request will be fired on (timeToWakeUP - heatAmount)
 - snoozeAmount : on scale of Minute. Should be initialized in range of 0..<60
 - daysToRepeat : Mon/Tue/Wed/Thu/Fri/Sat/Sun
*/
struct AlarmItem {
    var timeToWakeUp:(Int,Int)
    var isActive:Bool = true
    var timeToHeat:Int = 15
    var snoozeAmount:Int = 15
    var repeatDays:[Day] = [.Mon,.Tue,.Wed,.Thu,.Fri]
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
        self.timeToHeat
         = heatAmount
        self.snoozeAmount = snoozeAmount
        self.repeatDays = repeatDays
    }
}

//MARK: Helper Functions
extension AlarmItem{
    static func validityOfTime(_ hour:Int, _ minute:Int)->Bool{
        return validityOfHour(hour) && validityOfMinute(minute)
    }
    
    static func validityOfHour(_ hour:Int)->Bool{
        return (hour>=0 && hour<24)
    }
    
    static func validityOfMinute(_ minute:Int)->Bool{
        return (minute>=0 && minute<60)
    }
}
