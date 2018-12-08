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
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction private func cancelHandlerButton(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: SetUp 될 것들
    private var timeToHeatBeforeAwake:TimeInterval!
    private var timeToHeatAfterAsleep:TimeInterval!
    private var timeToSnooze:TimeInterval!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        timeToHeatAfterAsleepSlider.delegate = self
        timeToHeatBeforeAwakeSlider.delegate = self
        timeToSnoozeSlider.delegate = self
    }
    /// 이 ViewController의 속성값들을 초기화하고, 이 속성값들을 바탕으로 슬라이더의 위치를 조정
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: timeToHeatBeforeAwakeKey) == nil { initPropertiesFromDefaultValues() }
        else{ initPropertiesFrom(UserDefaults.standard) }
        setUpSlidersWithProperties()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        savePropertiesInUserDefaults()
    }
}

extension SetUpViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK : 슬라이더View의 Delegate
extension SetUpViewController:SliderSettingCellDelegate{
    /// 슬라이더가 슬라이드 되었을 때마다 불리는 함수
    /// - parameter changer : 슬라이더의 Accesibility Hint 
    /// - parameter changedValue : 슬라이드된 값
    func didSliderValueChanged(on changer: String?, _ changedValue: Float) {
        switch changer{
            case "잠든 뒤 전기장판 끄는 시간을 정하는 슬라이더"?:
                timeToHeatAfterAsleep = TimeInterval(Int(changedValue) * 60)
            case "일어나기 전 전기장핀 켜는 시간 정하는 슬라이더"?:
                timeToHeatBeforeAwake = TimeInterval(Int(changedValue) * 60)
            case "스누즈 시간을 정하는 슬라이더"?:
                timeToSnooze = TimeInterval(Int(changedValue) * 60)
            default:
                print("Unexpected changer")
        }
    }
}


// MARK: 초기화 메서드들
extension SetUpViewController{
    private func initPropertiesFromDefaultValues(){
        timeToHeatBeforeAwake = defaultTimeToHeatBeforeAwake
        timeToHeatAfterAsleep = defaultTimeToHeatAfterAsleep
        timeToSnooze = defaultTimeToSnooze
    }
    
    private func initPropertiesFrom(_ userDefaults:UserDefaults){
        timeToHeatBeforeAwake = userDefaults.double(forKey: timeToHeatBeforeAwakeKey)
        timeToHeatAfterAsleep = userDefaults.double(forKey: timeToHeatAfterAleepKey)
        timeToSnooze = userDefaults.double(forKey: timeToSnoozeKey)
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
