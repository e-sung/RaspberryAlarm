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
    // MARK: Delegate
    var delegate:SliderSettingCellDelegate?
    //MARK: IBOutlets
    @IBOutlet private weak var titleLB:UILabel!
    @IBOutlet private weak var quantityLB:UILabel!
    @IBOutlet private weak var slider:UISlider!
    // MARK: IBActions
    @IBAction private func updateQuantity(_ sender:UISlider){
        quantityLB.text = "\(Int(sender.value))분 " + "\(self.suffix)"
        delegate?.didSliderValueChanged(self.tag , sender.value)
    }
    
    // MARK: 초기화
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}

// MARK: Label들에 표시될 정보를 계산하는 연산프로퍼티들
extension SliderSettingCell{
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

}

protocol SliderSettingCellDelegate {
    func didSliderValueChanged(_ changer:Int, _ changedValue:Float)
}
