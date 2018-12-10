//
//  CircularClockViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 21..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit
import RAFoundation
import HGCircularSlider
import HealthKit
import HealthKitHelper

public class CircularClockViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet var amPmSgementControl: UISegmentedControl!
    @IBOutlet var hourIndicatingSlider: CircularSlider!
    @IBOutlet var minuteIndicatingSlider: CircularSlider!
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var minuteLabel: UILabel!
    
    var authRequestor: HealthKitAuthRequestor = HealthKitHelper.shared

    public static var storyboardInstance: CircularClockViewController {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        return sb.instantiateViewController(withIdentifier: "CircularClockViewController") as! CircularClockViewController
    }

    // MARK: 생명주기
    override public func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        authRequestor.requestSleepAuthorization(completion: { authorized, error in
            guard let error = error else { return }
            print(error.localizedDescription)
        })
    }
    
    // MARK: IBActions
    @IBAction func hourChangeHandler(_ sender: CircularSlider) {
        let hour = Int(sender.endPointValue)
        hourLabel.text = hour < 10 ? "0\(hour):" : "\(hour):"
        UserDefaults.standard.set(hour, forKey: wakeUpHourKey)
    }
    
    @IBAction func minuteChangeHandler(_ sender: CircularSlider) {
        let minute = Int(sender.endPointValue)
        minuteLabel.text = minute < 10 ? "0\(minute)" : "\(minute)"
        UserDefaults.standard.set(minute, forKey: wakeUpMinuteKey)
    }
    
    @IBAction func ampmChangeHandler(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: ampmKey)
    }
    
    @IBAction func unwindToCicularClock(_ unwindSegue: UIStoryboardSegue) {
    }
    
}

// MARK: 초기화 메서드들
extension CircularClockViewController{
    func initViews(){
        setUpHour(with: wakeUpHour)
        setUpMinute(with: wakeUpMinute)
    }
    
    private func setUpHour(with hour:Int){
        hourIndicatingSlider.endPointValue = CGFloat(hour)
        hourLabel.text = hour > 10 ? "\(hour):" : "0\(hour):"
    }
    
    private func setUpMinute(with minute:Int){
        minuteIndicatingSlider.endPointValue = CGFloat(minute)
        minuteLabel.text = minute > 10 ? "\(minute)" : "0\(minute)"
    }
}

// MARK: UserDefaults저장된 "일어날 시간"을 가져오거나, 디폴트값을 가져옴
extension CircularClockViewController{
    private var wakeUpHour:Int{
        if let wakeUpHour = UserDefaults.standard.object(forKey: wakeUpHourKey){
            return wakeUpHour as? Int ?? defaultWakeUpHour
        }
        return defaultWakeUpHour
    }
    private var wakeUpMinute:Int{
        if let wakeUpMinute = UserDefaults.standard.object(forKey: wakeUpMinuteKey){
            return wakeUpMinute as? Int ?? defaultWakeUpMinute
        }
        return defaultWakeUpMinute
    }
}
