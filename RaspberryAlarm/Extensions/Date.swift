//
//  Date.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 18..
//  Copyright © 2017년 류성두. All rights reserved.
//

import Foundation

extension Date{
    /**
    주어진 Date객체가 속한 날의 0시0분0초 부터 Date객체 본인까지의 Interval
     ````
     오늘자정.absoluteSeconds == 0
     내일자정.absoluteSeconds == 0
     오늘정오.absoluteSeconds == 12*60*60
     내일정오.absoluteSeconds == 12*60*60
     ````
    */
    var absoluteSeconds:TimeInterval{
        get{
            let hour = Calendar.current.component(.hour, from: self)
            let minute = Calendar.current.component(.minute, from: self)
            let second = Calendar.current.component(.second, from: self)
            return TimeInterval(hour*60*60 + minute*60 + second)
        }
    }
    /// Date 객체가 속한 날의 자정시점의 Date객체
    var midnight:Date{
        get{
            return Calendar.current.date(bySetting: .hour, value: 0, of: self)!
        }
    }
}
