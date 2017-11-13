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
//    var alarmsOfToday:[AlarmItem]{
//        get{
//            let today = Calendar.current.component(.weekday, from: Date())
//        }
//    }
}
