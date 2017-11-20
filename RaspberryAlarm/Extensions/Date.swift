//
//  Date.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 18..
//  Copyright © 2017년 류성두. All rights reserved.
//

import Foundation

extension Date{
    static let mainDateFormat = "HH:mm:ss"
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
    /**
     초단위의 시간을 넣으면 dateFormat 형식의 문자열 반환
     - parameter seconds : 변환하고자 하는 초단위의 시간
     - parameter dateFormat : "HH:mm:ss"등, [ISO8601](https://ko.wikipedia.org/wiki/ISO_8601) 표준을 따르는 형식
     ````
     format(seconds:10.0, with "HH:mm:ss") // 00:00:10
     format(seconds:2*60*60+60*4+3, with "HH:mm:ss") // 02:04:03
     ````
     */
    static func format(seconds:TimeInterval, with dateFormat:String)->String{
        let formatter = DateFormatter(); formatter.dateFormat = dateFormat
        let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        return formatter.string(from: Date(timeInterval: seconds, since: today))
    }
    /// Date 객체가 속한 날의 자정시점의 Date객체
    var midnight:Date{
        get{
            return Calendar.current.date(bySetting: .hour, value: 0, of: self)!
        }
    }
}
