//
//  DateFormatter.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 20..
//  Copyright © 2017년 류성두. All rights reserved.
//

import Foundation

extension DateFormatter{
    public static let mainDateFormat = "HH:mm:ss"
    /**
     초단위의 시간을 넣으면 dateFormat 형식의 문자열 반환
     - parameter seconds : 변환하고자 하는 초단위의 시간
     - parameter dateFormat : "HH:mm:ss"등, [ISO8601](https://ko.wikipedia.org/wiki/ISO_8601) 표준을 따르는 형식
     ````
     format(seconds:10.0, with "HH:mm:ss") // 00:00:10
     format(seconds:2*60*60+60*4+3, with "HH:mm:ss") // 02:04:03
     ````
     */
    public func format(seconds:TimeInterval, with dateFormat:String)->String{
        self.dateFormat = dateFormat
        let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        return self.string(from: Date(timeInterval: seconds, since: today))
    }
}
