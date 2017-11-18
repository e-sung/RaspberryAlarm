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
     현재 시간을 HH:mm:ss 모양의 문자열로 바꿔주는 계산속성
     
     - Remark:
     사실 구현한 내용을 그냥 매번 코드에 써도 되는데,
     별 것도 아닌게 2줄이나 차지하는게 마음에 안들어서 만들었음
     */
    static var currentHHmmss:String{
        get{
            let dateFormatter = DateFormatter(); dateFormatter.dateFormat = "HH:mm:ss"
            return dateFormatter.string(from: Date())
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
