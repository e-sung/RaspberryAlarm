//
//  MainViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 21..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit
import HGCircularSlider

class MainViewController: UIViewController {
    @IBOutlet private weak var hourIndicatingSlider: CircularSlider!
    @IBOutlet private weak var minuteIndicatingSlider: CircularSlider!
    @IBOutlet private weak var hourLabel: UILabel!
    @IBOutlet private weak var minuteLabel: UILabel!
    
    @IBAction private func hourChangeHandler(_ sender: CircularSlider) {
        let hour = Int(sender.endPointValue)
        hourLabel.text = hour < 10 ? "0\(hour):" : "\(hour):"
        UserDefaults.standard.set(hour, forKey: wakeUpHourKey)
    }
    
    @IBAction private func minuteChangeHandler(_ sender: CircularSlider) {
        let minute = Int(sender.endPointValue)
        minuteLabel.text = minute < 10 ? "0\(minute)" : "\(minute)"
        UserDefaults.standard.set(minute, forKey: wakeUpMinuteKey)
    }
    
    @IBAction private func ampmChangeHandler(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: ampmKey)
    }
    private let defaultWakeUpHour = 6
    private let defaultWakeUpMinute = 30
    
    private var wakeUpHour:Int{
        get{
            if UserDefaults.standard.object(forKey: wakeUpHourKey) == nil {
                return defaultWakeUpHour
            }else{
                return UserDefaults.standard.integer(forKey: wakeUpHourKey)
            }
        }
    }
    
    private var wakeUpMinute:Int{
        get{
            if UserDefaults.standard.object(forKey: wakeUpMinuteKey) == nil {
                return defaultWakeUpMinute
            }else{
                return UserDefaults.standard.integer(forKey: wakeUpMinuteKey)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews(){
        setUp(hour: wakeUpHour)
        setUp(minute: wakeUpMinute)
    }
    
    private func setUp(hour:Int){
        hourIndicatingSlider.endPointValue = CGFloat(hour)
        hourLabel.text = hour > 10 ? "\(hour):" : "0\(hour):"
    }
    
    private func setUp(minute:Int){
        minuteIndicatingSlider.endPointValue = CGFloat(minute)
        minuteLabel.text = minute > 10 ? "\(minute)" : "0\(minute)"
    }
}
