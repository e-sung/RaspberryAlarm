//
//  ViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class AlarmListViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource{
    
    let alarmItem = AlarmItem((7, 30))!
    
    @IBOutlet weak var alarmListView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmListView.delegate = self
        alarmListView.dataSource = self
    }
}

extension AlarmListViewController{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alarmItemCell = tableView.dequeueReusableCell(withIdentifier: "alarmItemCell", for: indexPath) as! AlarmItemCell
        alarmItemCell.alarmItem = self.alarmItem
        return alarmItemCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
}
