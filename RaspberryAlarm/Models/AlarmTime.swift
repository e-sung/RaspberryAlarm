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
    var second:Int
    var absoluteSeconds:Int{
        get{
            return hour*60*60 + minute*60 + second
        }
    }
}
