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
            self.timeLB.text = Date.format(seconds: newItem.timeToWakeUp, with:"HH:mm" )
            color(the: self.dayLabels, of: newItem.repeatDays)
        }
    }
    
    private var dayLabels:[UILabel]{
        get{
            var labelsToReturn:[UILabel] = []
            for i in 1...7{
                labelsToReturn.append(self.viewWithTag(i) as! UILabel)
            }
            return labelsToReturn
        }
    }

    private var _alarmItem:AlarmItem!
    @IBOutlet private weak var timeLB:UILabel!
    @IBAction private func switchToggleHandler(_ sender:UISwitch){
    }

    private func color(the dayLabels:[UILabel], of repeatingDays:[Day]){
        for label in dayLabels{
            if repeatingDays.contains(Day(rawValue: label.tag)!){
                label.textColor = .green
            }else{
                label.textColor = .lightGray
            }
        }
    }
    
}
