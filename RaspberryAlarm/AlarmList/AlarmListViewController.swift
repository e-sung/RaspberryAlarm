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
}
