//
//  SliderSettingCell.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

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
            quantityLB.text = "\(Int(newVal!))"
        }
    }
    @IBOutlet private weak var titleLB:UILabel!
    @IBOutlet private weak var quantityLB:UILabel!
    @IBOutlet private weak var slider:UISlider!
    
    @IBAction private func updateQuantity(_ sender:UISlider){
        quantityLB.text = "\(Int(sender.value))"
        delegate.didSliderValueChanged(titleLB.text!, Int(sender.value))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        quantityLB.text = "\(Int(slider.value))"
    }
}

protocol SliderSettingCellDelegate {
    func didSliderValueChanged(_ changer:String, _ changedValue:Int)
}
