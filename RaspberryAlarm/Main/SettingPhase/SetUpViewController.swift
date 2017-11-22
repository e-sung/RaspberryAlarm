//
//  SetUpAlarmViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//
import UIKit

class SetUpViewController: UIViewController, UINavigationControllerDelegate{
    
    // MARK: IBOutlets
    @IBOutlet private weak var timeToHeatAfterAsleepSlider: SliderSettingCell!
    @IBOutlet private weak var timeToHeatBeforeAwakeSlider: SliderSettingCell!
    @IBOutlet private weak var timeToSnoozeSlider: SliderSettingCell!
    
    // MARK: IBAction
    @IBAction private func confirmButtonHandler(_ sender: UIBarButtonItem) {
        savePropertiesInUserDefaults()
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: 이 SetUpViewController에서 SetUp하고자 하는 속성들
    private var timeToHeatBeforeAwake:TimeInterval!
    private var timeToHeatAfterAsleep:TimeInterval!
    private var timeToSnooze:TimeInterval!
    
    // MARK: 이 SetUpViewController에서 SetUp하고자 하는 속성들의 기본값
    private let defaultTimeToHeatBeforeAwake = 30.0*60.0
    private let defaultTimeToHeatAfterAsleep = 30.0*60.0
    private let defaultTimeToSnooze = 15.0*60.0
    
    // MARK: LifeCycle
    /// Delegate선언
    override func viewDidLoad() {
        super.viewDidLoad()
        timeToHeatAfterAsleepSlider.delegate = self
        timeToHeatBeforeAwakeSlider.delegate = self
        timeToSnoozeSlider.delegate = self
    }
    /// 이 ViewController의 속성값들을 초기화하고, 이 속성값들을 바탕으로 슬라이더의 위치를 조정
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: timeToHeatBeforeAwakeKey) == nil {
            initPropertiesFromDefaultValues()
        }else{
            initPropertiesFromUserDefaults()
        }
        setUpSlidersWithProperties()
    }
}

// MARK : 슬라이더View의 Delegate
extension SetUpViewController:SliderSettingCellDelegate{
    /// 슬라이더가 슬라이드 되었을 때마다 불리는 함수
    /// - parameter changer : 슬라이드된 슬라이더의 식별자
    /// - parameter changedValue : 슬라이드된 값
    func didSliderValueChanged(_ changer: Int, _ changedValue: Float) {
        switch changer {
        case nightTimeChanger:
            timeToHeatAfterAsleep = TimeInterval(Int(changedValue) * 60)
        case morningTimeChanger:
            timeToHeatBeforeAwake = TimeInterval(Int(changedValue) * 60)
        case snoozeTimeChanger:
            timeToSnooze = TimeInterval(Int(changedValue) * 60)
        default:
            print("Unexpected changer tag")
        }
    }
}


extension SetUpViewController{
    private func initPropertiesFromDefaultValues(){
        timeToHeatBeforeAwake = defaultTimeToHeatBeforeAwake
        timeToHeatAfterAsleep = defaultTimeToHeatAfterAsleep
        timeToSnooze = defaultTimeToSnooze
    }
    
    private func initPropertiesFromUserDefaults(){
        timeToHeatBeforeAwake = UserDefaults.standard.double(forKey: timeToHeatBeforeAwakeKey)
        timeToHeatAfterAsleep = UserDefaults.standard.double(forKey: timeToHeatAfterAleepKey)
        timeToSnooze = UserDefaults.standard.double(forKey: timeToSnoozeKey)
    }
    
    private func setUpSlidersWithProperties(){
        timeToHeatBeforeAwakeSlider.quantity = Float(Int(timeToHeatBeforeAwake/60))
        timeToHeatAfterAsleepSlider.quantity = Float(Int(timeToHeatAfterAsleep/60))
        timeToSnoozeSlider.quantity = Float(Int(timeToSnooze/60))
    }
    
    private func savePropertiesInUserDefaults(){
        UserDefaults.standard.set(TimeInterval(timeToHeatBeforeAwake), forKey: timeToHeatBeforeAwakeKey)
        UserDefaults.standard.set(TimeInterval(timeToHeatAfterAsleep), forKey: timeToHeatAfterAleepKey)
        UserDefaults.standard.set(TimeInterval(timeToSnooze), forKey: timeToSnoozeKey)
    }
}
