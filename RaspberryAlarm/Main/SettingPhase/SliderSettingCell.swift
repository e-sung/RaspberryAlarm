//
//  SliderSettingCell.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

let nightTimeChanger = 1
let morningTimeChanger = 2
let snoozeTimeChanger = 3
class SliderSettingCell: UITableViewCell{

    var delegate:SliderSettingCellDelegate!
    var title:String?{
        get{
            return titleLB.text
        }
        set(newVal){
            titleLB.text = newVal
        }
    }
    var quantity:Float?{
        get{
            return slider.value
        }
        set(newVal){
            slider.value = newVal!
            quantityLB.text = "\(Int(newVal!))분 " + "\(self.suffix)"
        }
    }
    private var suffix:String{
        get{
            switch self.tag {
            case nightTimeChanger:
                return "뒤"
            case morningTimeChanger:
                return "전"
            default:
                return ""
            }
        }
    }

    @IBOutlet private weak var titleLB:UILabel!
    @IBOutlet private weak var quantityLB:UILabel!
    @IBOutlet private weak var slider:UISlider!
    @IBAction private func updateQuantity(_ sender:UISlider){
        quantityLB.text = "\(Int(sender.value))분 " + "\(self.suffix)"
        delegate.didSliderValueChanged(self.tag , sender.value)
    }
    
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}

protocol SliderSettingCellDelegate {
    func didSliderValueChanged(_ changer:Int, _ changedValue:Float)
}
