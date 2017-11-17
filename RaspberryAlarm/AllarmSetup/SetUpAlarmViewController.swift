//
//  SetUpAlarmViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class SetUpAlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate{
    
    var alarmItem:AlarmItem!
    private var navControllerVC:SetUpAlarmNavigationViewController!
    
    @IBOutlet private weak var settingItemTV: UITableView!
    @IBAction private func cancelButtonHandler(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction private func confirmButotnHandler(_ sender: UIBarButtonItem){
        DataCenter.main.alarmItems[navControllerVC.indexOfAlarmToSetUp] = self.alarmItem
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToSetUpAlarmVC(segue:UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingItemTV.delegate = self
        settingItemTV.dataSource = self
        navControllerVC = navigationController as! SetUpAlarmNavigationViewController
        self.alarmItem = DataCenter.main.alarmItems[navControllerVC.indexOfAlarmToSetUp]
    }
}

extension SetUpAlarmViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reuseId = ""
        
        var cellTitle = ""
        var sliderValue:Float = 15.0
        switch indexPath.item {
        case 0:
            reuseId = "normalCell"
            cellTitle = "시간설정"
        case 1:
            reuseId = "normalCell"
            cellTitle = "반복설정"
        case 2:
            reuseId = "sliderCell"
            cellTitle = "스누즈 설정"
            sliderValue = Float(alarmItem.snoozeAmount/60)
        case 3:
            reuseId = "sliderCell"
            cellTitle = "전기장판 설정"
            sliderValue = Float(alarmItem.timeToHeat/60)
        default:
            print("Unidentified indexPath")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId)!
        if indexPath.item<2{
            cell.textLabel?.text = cellTitle
            cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: CGFloat(30))
            return cell
        }else{
            let sliderCell = cell as! SliderSettingCell
            sliderCell.delegate = self
            sliderCell.title = cellTitle
            sliderCell.quantity = sliderValue
            return sliderCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item < 2{
            return CGFloat(70)
        }
        return CGFloat(100)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            performSegue(withIdentifier: "showWakeUpTimeSetUp", sender: indexPath.item)
        case 1:
            performSegue(withIdentifier: "showRepeatDaysSetUp", sender: indexPath.item)
        default:
            print("unexpected indexPath")
        }
    }
}

extension SetUpAlarmViewController:SliderSettingCellDelegate{
    func didSliderValueChanged(_ changer: String, _ changedValue: Int) {
        if changer == "스누즈 설정"{
            self.alarmItem.snoozeAmount = changedValue*60
        }else{
            self.alarmItem.timeToHeat = changedValue*60
        }
    }
}
