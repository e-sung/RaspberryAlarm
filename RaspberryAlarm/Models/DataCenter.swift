//
//  DataCenter.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import Foundation

/**
 초기화면에 표시해야 할 모든 '알람'아이템들의 객체를 가지고 있는 클래스
 싱글턴 패턴 활용
*/
class DataCenter{
    
    let alarmListFileName = "alarmList.plist"
    var documentUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(alarmListFileName)
    }
    var documentPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                   .userDomainMask, true).first! + "/" + alarmListFileName
    }
    
    /// 싱글턴 객체
    static var main:DataCenter = DataCenter()
    /// 초기화면에 표시되어야 할 모든 알람들의 배열
    var alarmItems:[AlarmItem] = []{
        didSet(oldVal){
            write(list: alarmItems, to: documentPath)
        }
    }
    /**
    초기화면 우측하단의 초승달을 눌렀을 때, 실행되어야 할 알람
    1. 오늘의 알람들을 시간순으로 정렬하고,
    2. 가장 빨리 울릴 알람들부터 "현재시간"과 비교해서
    3. 현재시간보다 늦게 울린다면, 그 알람을 리턴
    4. 오늘의 알람 모두가 "현재시간"보다 빨리 울린다면 내일 가장 먼저 울릴 알람을 리턴
    5. 내일 울릴 알람이 아예 없다면 nil을 리턴
    */
    var nearestAlarm:AlarmItem?{
        get{
            let today = Day(rawValue:Calendar.current.component(.weekday, from: Date()))!
            let tomorrow = Day(rawValue:Calendar.current.component(.weekday, from:
                Date(timeInterval: 24*60*60, since: Date())))!

            for item in AlarmItem.availableAlarms(on: today, given: alarmItems){
                if item.timeToWakeUp > Date().absoluteSeconds{
                    return item
                }
            }
            let alarmsOfTomorrow = AlarmItem.availableAlarms(on: tomorrow, given: alarmItems)
            if alarmsOfTomorrow.count > 0 {
                return alarmsOfTomorrow[0]
            }else{
                return nil
            }
        }
    }
    
    private init(){
        if !FileManager.default.fileExists(atPath: documentPath){
            do{
                try FileManager.default.copyItem(
                    at: Bundle.main.url(forResource: "alarmList", withExtension: "plist")!,
                    to: documentUrl)
            }catch{
                print("\(alarmListFileName) copy failed")
            }
        }
        let decoder = PropertyListDecoder()
        let loadedArray = loadContents(from: alarmListFileName)
        for item in loadedArray as! [Data]{
            if let alarmItem = try? decoder.decode(AlarmItem.self, from: item){
                self.alarmItems.append(alarmItem)
            }
        }
    }
    
    func loadContents(from file:String)->NSArray? {
        guard let documentRenewedPlistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(file) else {
            print("document renewed plist url wasn't generated")
            return nil
        }
        return NSArray(contentsOf: documentRenewedPlistURL)
    }
    
    func write(list:[AlarmItem], to path:String){
        var alarmsToSave:[Any] = []
        for item in list{
            let encodedItem = try! PropertyListEncoder().encode(item)
            alarmsToSave.append(encodedItem)
        }
        NSArray(array: alarmsToSave).write(toFile: path, atomically: true)
    }
}
