//
//  File.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 18..
//  Copyright © 2017년 류성두. All rights reserved.
//

import Foundation

struct AlarmTime{
    var hour:Int
    var minute:Int
    var second:Int = 0
    var absoluteSeconds:Int{
        get{
            return hour*60*60 + minute*60 + second
        }
    }
    
    init(hour:Int, minute:Int){
        self.hour = hour
        self.minute = minute
    }
    
    init(hour:Int, minute:Int, second:Int){
        self.hour = hour
        self.minute = minute
        self.second = second
    }

    init(with date:Date) {
        let formatter = DateFormatter(); formatter.dateFormat = "HH:mm"
        let dateString = formatter.string(from: date)

        self.hour = Int(dateString.split(separator: ":")[0])!
        self.minute = Int(dateString.split(separator: ":")[1])!
    }
}
