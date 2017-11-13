//
//  AlarmListViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class AlarmListViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var alarmListView:UITableView!
    @IBAction func addButtonHandler(_ sender: UIButton) {
        let newAlarmItem = DataCenter.main.defaultAlarm
        DataCenter.main.alarmItems.append(newAlarmItem)
        alarmListView.reloadData()
    }
    
    @IBAction func recordButtonHandler(_ sender: UIButton) {
        performSegue(withIdentifier: "showRecordingPhase", sender: nil)
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
        if let indexToSend = sender as? Int{
            let nextVC = segue.destination as! SetUpAlarmNavigationViewController
            nextVC.indexOfAlarmToSetUp = indexToSend
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

}
