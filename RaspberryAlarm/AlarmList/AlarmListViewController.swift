//
//  AlarmListViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit
import AVFoundation

class AlarmListViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var alarmListView:UITableView!
    @IBAction func addButtonHandler(_ sender: UIButton) {
        let newAlarmItem = DataCenter.main.defaultAlarm
        DataCenter.main.alarmItems.append(newAlarmItem)
        alarmListView.reloadData()
    }
    
    @IBAction func recordButtonHandler(_ sender: UIButton) {
        if let alarm = DataCenter.main.nearestAlarm {
            performSegue(withIdentifier: "showRecordingPhase", sender: alarm)
        }else{
           alert(msg: "설정된 알람이 없습니다!")
        }
    }
    
    @IBAction func unwindToAlarmList(segue:UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmListView.delegate = self
        alarmListView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        alarmListView.reloadData()
    }
}

extension AlarmListViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? RecordingPhaseViewController{
            nextVC.alarmItem = sender as! AlarmItem
        }else if let nextVC = segue.destination as? SetUpAlarmNavigationViewController{
            nextVC.indexOfAlarmToSetUp = sender as! Int
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
}

extension AlarmListViewController{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataCenter.main.alarmItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alarmItemCell = tableView.dequeueReusableCell(withIdentifier: "alarmItemCell", for: indexPath) as! AlarmItemCell
        alarmItemCell.alarmItem = DataCenter.main.alarmItems[indexPath.item]
        return alarmItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSetUpAlarm", sender: indexPath.item)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        DataCenter.main.alarmItems.remove(at: indexPath.item)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

}

extension AlarmListViewController{
    /**
     UIAlertController 를 쉽게 쓰게 만드는 함수.
     - ToDo : 더 쓰일 곳이 생기면, 파일 하나 새로 만들자.
     */
    func alert(msg:String){
        let alert = UIAlertController(title: "안내", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel , handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
