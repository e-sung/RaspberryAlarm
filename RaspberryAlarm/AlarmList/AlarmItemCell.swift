//
//  AlarmItemCell.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class AlarmItemCell: UITableViewCell {
    
    var alarmItem:AlarmItem{
        get{
            return _alarmItem
        }
        set(newItem){
            self._alarmItem = newItem
            let hour = newItem.timeToWakeUp.0
            let minute = newItem.timeToWakeUp.1
            self.timeLB.text = "\(hour):\(minute)"
        }
    }
    private var _alarmItem:AlarmItem!
    @IBOutlet weak var timeLB:UILabel!
    @IBAction func switchToggleHandler(_ sender:UISwitch){
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
