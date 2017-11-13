//
//  DataCenter.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import Foundation

class DataCenter{
    static var main:DataCenter = DataCenter()
    let defaultAlarm = AlarmItem((6,30))!
    var alarmItems:[AlarmItem] = []{
        didSet(oldVal){
        }
    }
    var nearestAlarm:AlarmItem?{
        get{
            let currentHour = Calendar.current.component(.hour, from: Date())
            let currentMinute = Calendar.current.component(.minute, from: Date())
            for item in alarmsOfDay(with: 0, shouldBeSorted: true){
                if item.timeToWakeUp.0 > currentHour &&
                    item.timeToWakeUp.1 > currentMinute{
                    return item
                }
            }
            let alarmsOfTomorrow = alarmsOfDay(with: 1, shouldBeSorted: true)
            if alarmsOfTomorrow.count > 0 {
                return alarmsOfTomorrow[0]
            }else{
                return nil
            }
        }
    }
    
    /**
     AlarmItems of a day that user specified with offSet
     
     ````
     let todayAlarms = alarmsOfDay(with 0)
     let tomorrowAlarms = alarmsOfDay(with 1)
     ````
     */
    private func alarmsOfDay(with offSet:Int, shouldBeSorted:Bool)->[AlarmItem]{
        var alarmsToReturn:[AlarmItem] = []
        let day = (Calendar.current.component(.weekday, from: Date()) + 1)%7
        for item in alarmItems{
            if item.repeatDays.contains(Day(rawValue: day)!){
                alarmsToReturn.append(item)
            }
        }
        if shouldBeSorted {
            alarmsToReturn.sort { (item1, item2) -> Bool in
                let wt1 = item1.timeToWakeUp.0*60 + item1.timeToWakeUp.1
                let wt2 = item2.timeToWakeUp.0*60 + item2.timeToWakeUp.1
                return wt1 < wt2
            }
        }
        return alarmsToReturn
    }
}
