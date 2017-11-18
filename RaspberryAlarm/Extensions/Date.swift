//
//  Date.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 18..
//  Copyright © 2017년 류성두. All rights reserved.
//

import Foundation

extension Date{
    
    var absoluteSeconds:Int{
        get{
            let hour = Calendar.current.component(.hour, from: self)
            let minute = Calendar.current.component(.minute, from: self)
            let second = Calendar.current.component(.second, from: self)
            return hour*60*60 + minute*60 + second
        }
    }
    /**
     초단위의 시간을 넣으면 "HH:mm:ss" 형식의 문자열 반환
     */
    static func format(seconds:Int, with dateFormat:String)->String{
        let formatter = DateFormatter(); formatter.dateFormat = dateFormat
        let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        return formatter.string(from: Date(timeInterval: Double(seconds), since: today))
    }
}
