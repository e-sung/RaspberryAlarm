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
    @IBOutlet var sliderCells: [SliderSettingCell]!
    
    // MARK: IBAction
    @IBAction private func confirmButtonHandler(_ sender: UIBarButtonItem) {
        savePropertiesInUserDefaults()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction private func cancelHandlerButton(_ sender: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: 이 SetUpViewController에서 SetUp하고자 하는 속성들
    /// 1. 잠들고 전기장판 끌 시간
    /// 2. 일어나기 전 전기장판 켤 시간
    /// 3. 뒤척일 시간
    private var timesToSet:[TimeInterval] = [
        appDefault[timeTo.turnOn.rawValue],
        appDefault[timeTo.turnOff.rawValue],
        appDefault[timeTo.snooze.rawValue]
    ]

    // MARK: LifeCycle
    /// Delegate선언
    override func viewDidLoad() {
        super.viewDidLoad()
        for sliderCell in sliderCells{
            sliderCell.delegate = self
        }
    }
    /// 이 ViewController의 속성값들을 초기화하고, 이 속성값들을 바탕으로 슬라이더의 위치를 조정
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: keysForTimesToSetUpInSettingPhase[0]) != nil {
            initPropertiesFromUserDefaults()
        }
        setUpSlidersWithProperties()
    }
}

// MARK : 슬라이더View의 Delegate
extension SetUpViewController:SliderSettingCellDelegate{
    /// 슬라이더가 슬라이드 되었을 때마다 불리는 함수
    /// - parameter changer : 슬라이드된 슬라이더의 Tag
    /// - parameter changedValue : 슬라이드된 값
    func didSliderValueChanged(_ changer: Int, _ changedValue: Float) {
        timesToSet[changer-1] = TimeInterval(Int(changedValue) * 60)
    }
}


// MARK: 초기화 메서드들
/// - Todo : IBOutletCollections 활용
extension SetUpViewController{
    private func initPropertiesFromUserDefaults(){
        for i in 0..<timesToSet.count{
            timesToSet[i] = UserDefaults.standard.double(forKey: keysForTimesToSetUpInSettingPhase[i])
        }
    }
    
    private func setUpSlidersWithProperties(){
        for i in 0..<timesToSet.count{
            sliderCells[i].quantity = Float(Int(timesToSet[i]/60))
        }
    }
    
    private func savePropertiesInUserDefaults(){
        for i in 0..<timesToSet.count{
            UserDefaults.standard.set(timesToSet[i], forKey: keysForTimesToSetUpInSettingPhase[i])
        }
    }
}

enum timeTo:Int{
    case turnOff = 0
    case turnOn = 1
    case snooze = 2
}
