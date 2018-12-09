//
//  SliderSettingCell.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class SliderSettingCell: UITableViewCell{
    // MARK: Delegate
    var delegate:SliderSettingCellDelegate?
    //MARK: IBOutlets
    @IBOutlet private var titleLB:UILabel!
    @IBOutlet private var quantityLB:UILabel!
    @IBOutlet private var slider:UISlider!
    // MARK: IBActions
    @IBAction private func updateQuantity(_ sender:UISlider){
        quantityLB.text = "\(Int(sender.value))"
        delegate?.didSliderValueChanged(on: slider.accessibilityHint, sender.value)
    }
    // MARK: 초기화
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}

// MARK: Label들에 표시될 정보를 계산하는 연산프로퍼티
extension SliderSettingCell{
    var quantity:Float?{
        get{return slider.value}
        set(newVal){slider.value = newVal!;quantityLB.text = "\(Int(newVal!))"}
    }
}

// MARK: Delegate 함수
protocol SliderSettingCellDelegate {
    func didSliderValueChanged(on changer:String?, _ changedValue:Float)
}
