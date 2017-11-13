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
    var navControllerVC:SetUpAlarmNavigationViewController!
    
    @IBOutlet weak var settingItemTV: UITableView!
    @IBAction func cancelButtonHandler(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmButotnHandler(_ sender: UIBarButtonItem){
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
        case 3:
            reuseId = "sliderCell"
            cellTitle = "전기장판 설정"
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
            sliderCell.titleLB.text = cellTitle
            sliderCell.delegate = self
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

extension SetUpAlarmViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // TODO use Protocol TO do this
        let rowIndex = sender as! Int
        switch rowIndex{
        case 0:
            let nextVC = segue.destination as! WakeUpTimeSetUpViewController
            nextVC.alarmItem = self.alarmItem
        case 1:
            let nextVC = segue.destination as! RepeatDaySetUpViewController
            nextVC.alarmItem = self.alarmItem
        default:
            print("unidentified segue identifier")
        }
    }
}

extension SetUpAlarmViewController:SliderSettingCellDelegate{
    func didSliderValueChanged(_ changer: String, _ changedValue: Int) {
        if changer == "스누즈 설정"{
            alarmItem.snoozeAmount = changedValue
        }else{
            alarmItem.timeToHeat = changedValue
        }
    }
}
