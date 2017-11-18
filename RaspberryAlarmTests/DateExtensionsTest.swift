//
//  DateExtensionsTest.swift
//  RaspberryAlarmTests
//
//  Created by 류성두 on 2017. 11. 18..
//  Copyright © 2017년 류성두. All rights reserved.
//

import XCTest
@testable import RaspberryAlarm

class DateExtensionsTest: XCTestCase {
    
    var week:[Date]!
    var hours:[Int:Date]!
    var minutes:[Int:Date]!
    let secondsInDay = 24*60*60
    override func setUp() {
        super.setUp()
        let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        week = [
            today,
            Date(timeInterval: TimeInterval(secondsInDay) , since: today),
            Date(timeInterval: TimeInterval(secondsInDay*2) , since: today),
            Date(timeInterval: TimeInterval(secondsInDay*3) , since: today),
            Date(timeInterval: TimeInterval(secondsInDay*4) , since: today),
            Date(timeInterval: TimeInterval(secondsInDay*5) , since: today),
            Date(timeInterval: TimeInterval(secondsInDay*6) , since: today),
        ]
        
        hours = [
            1 : Calendar.current.date(byAdding: .hour, value: 1, to: week[0])!,
            8 : Calendar.current.date(byAdding: .hour, value: 8, to: week[0])!,
            12 : Calendar.current.date(byAdding: .hour, value: 12, to: week[0])!,
            16 : Calendar.current.date(byAdding: .hour, value: 16, to: week[0])!,
            24 : Calendar.current.date(byAdding: .hour, value: 24, to: week[0])!,
        ]
        minutes = [
            1: Calendar.current.date(byAdding: .minute, value: 1, to: hours[1]!)!,
            30 : Calendar.current.date(byAdding: .minute, value: 30, to: hours[1]!)!,
            59 : Calendar.current.date(byAdding: .minute, value: 59, to: hours[1]!)!,
            60 : Calendar.current.date(byAdding: .minute, value: 60, to: hours[1]!)!,
        ]

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testAbsoluteSeconds(){
        XCTAssertEqual(week[0].absoluteSeconds, week[1].absoluteSeconds)
        XCTAssertEqual(hours[1]!.absoluteSeconds, 60*60)
        XCTAssertEqual(minutes[1]!.absoluteSeconds, 60*60 + 1*60)
        XCTAssertEqual(minutes[30]!.absoluteSeconds, 60*60 + 30*60)
    }
    
    func testSecondsFormatting(){
        XCTAssertEqual(Date.format(seconds: 0, with: "HH:mm:ss") , "00:00:00")
        XCTAssertEqual(Date.format(seconds: 10, with: "HH:mm:ss") , "00:00:10")
        XCTAssertEqual(Date.format(seconds: 2*60*60 + 4*60 + 3, with: "HH:mm:ss") , "02:04:03")
    }
}
