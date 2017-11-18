//
//  DataCenterTest.swift
//  RaspberryAlarmTests
//
//  Created by 류성두 on 2017. 11. 18..
//  Copyright © 2017년 류성두. All rights reserved.
//

import XCTest
@testable import RaspberryAlarm

class DataCenterTest: XCTestCase {
    
    var dataCenter:DataCenter!
    let defaultWakeUpTime:AlarmTime = AlarmTime(hour: 6, minute: 30)
    override func setUp() {
        super.setUp()
        dataCenter = DataCenter()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testNearestAlarmGivenEmptyList(){
        XCTAssert(dataCenter.nearestAlarm == nil)
    }
    
    func testNearestAlarmGivenAlarmOfDayAfterTomorrow(){
        //Given
        var alarmItem = AlarmItem()
        alarmItem.repeatDays = [getDay(of: getDayAfterTomorrow())]
        dataCenter.alarmItems.append(alarmItem)
        
        //When
        let nearestAlarmItem = dataCenter.nearestAlarm
        
        //Then
        XCTAssert(nearestAlarmItem == nil)
    }
    
    func testNearestAlarmGivenDefaultAlarms(){
        //Given
        dataCenter.alarmItems = [AlarmItem(), AlarmItem(),AlarmItem()]
        
        //When
        let nearestAlarm = dataCenter.nearestAlarm
        
        //Then
        if todayIsWeekEnd() {
           XCTAssert(nearestAlarm == nil)
        }else{
            guard let nearestAlarm = nearestAlarm else {
                XCTFail()
                return
            }
            XCTAssert(nearestAlarm.timeToWakeUp.absoluteSeconds == defaultWakeUpTime.absoluteSeconds)
        }
    }
    
    func testNearestAlarmGivenTwoAlarms(){
        let preceedingAlarmTime = AlarmTime(with: Date(timeInterval: 2000, since: Date()))
        let proceedingAlarmTime = AlarmTime(with: Date(timeInterval: 6000, since: Date()))
        var preceedingAlarmItem = AlarmItem(); preceedingAlarmItem.timeToWakeUp = preceedingAlarmTime
        preceedingAlarmItem.repeatDays = [getDay(of: Date())]
        var proceedingAlarmItem = AlarmItem(); proceedingAlarmItem.timeToWakeUp = proceedingAlarmTime
        proceedingAlarmItem.repeatDays = [getDay(of: Date())]
        dataCenter.alarmItems = [preceedingAlarmItem, proceedingAlarmItem]
        
        if let nearestWakeUpTime = dataCenter.nearestAlarm{
            XCTAssert(nearestWakeUpTime.timeToWakeUp.absoluteSeconds == preceedingAlarmTime.absoluteSeconds)
        }else{
            XCTFail()
        }

    }
    
    func todayIsWeekEnd()->Bool{
        let today = getDay(of: getToday())
        return today == .Sat || today == .Sun ? true : false
    }
    
    func getDay(of date:Date)->Day{
        return Day(rawValue:Calendar.current.component(.weekday, from: date))!
    }
    
    func getToday()->Date{
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    }
    
    func getTomorrow()->Date{
        let today = getToday()
        return Date(timeInterval: TimeInterval(24*60*60), since: today)
    }
    
    func getDayAfterTomorrow()->Date{
        let today = getToday()
        return Date(timeInterval: TimeInterval(2*24*60*60), since: today)
    }
    
}
