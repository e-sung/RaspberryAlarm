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
     - ToDo :
     TimeInterval은 Double 타입으로 만들어져있음.
     '초'단위는 전부 정수형으로 만들었는데, 다 Double로 바꿔야 할 듯
    */
    var absoluteSeconds:Int{
        get{
            let hour = Calendar.current.component(.hour, from: self)
            let minute = Calendar.current.component(.minute, from: self)
            let second = Calendar.current.component(.second, from: self)
            return hour*60*60 + minute*60 + second
        }
    }
    /**
     초단위의 시간을 넣으면 dateFormat 형식의 문자열 반환
     - parameter seconds : 변환하고자 하는 초단위의 시간
     - parameter dateFormat : "HH:mm:ss"등, [ISO8601](https://ko.wikipedia.org/wiki/ISO_8601) 표준을 따르는 형식
     ````
     format(seconds:10, with "HH:mm:ss") // 00:00:10
     format(seconds:2*60*60+60*4+3, with "HH:mm:ss") // 02:04:03
     ````
     - ToDo :
     seconds를 Double로 만들어야 함
     */
    static func format(seconds:Int, with dateFormat:String)->String{
        let formatter = DateFormatter(); formatter.dateFormat = dateFormat
        let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        return formatter.string(from: Date(timeInterval: Double(seconds), since: today))
    }
}
