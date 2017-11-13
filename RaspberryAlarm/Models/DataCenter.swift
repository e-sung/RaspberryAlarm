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
    var alarmItems:[AlarmItem] = []
    
    /**
    AlarmItems of a day that user specified with parameter
     - parameter offSet: if 0, it means today. if 1, it means tomorrow
     */
    func alarmsOfDay(with offSet:Int, )->[AlarmItem]{
        var alarmsToReturn:[AlarmItem] = []
        let day = (Calendar.current.component(.weekday, from: Date()) + 1)%7
        for item in alarmItems{
            if item.repeatDays.contains(Day(rawValue: day)!){
                alarmsToReturn.append(item)
            }
        }
        return alarmsToReturn
    }
}
