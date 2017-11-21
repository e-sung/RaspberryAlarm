//
//  MainViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 21..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit
import HGCircularSlider

class MainViewController: UIViewController {
    @IBOutlet weak var hourIndicatingSlider: CircularSlider!
    @IBOutlet weak var minuteIndicatingSlider: CircularSlider!
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "wakeUpHour") == nil {
            hourIndicatingSlider.endPointValue = 6.0
            minuteIndicatingSlider.endPointValue = 30.0
            hourLabel.text = "06:"
            minuteLabel.text = "30"
        }else{
            hourIndicatingSlider.endPointValue = CGFloat(UserDefaults.standard.integer(forKey: "wakeUpHour"))
            minuteIndicatingSlider.endPointValue = CGFloat(UserDefaults.standard.integer(forKey: "wakeUpMinute"))
            hourLabel.text = "\(UserDefaults.standard.integer(forKey: "wakeUpHour")):"
            minuteLabel.text = "\(UserDefaults.standard.integer(forKey: "wakeUpMinute"))"
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hourChangeHandler(_ sender: CircularSlider) {
        let hour = Int(sender.endPointValue)
        hourLabel.text = hour < 10 ? "0\(hour):" : "\(hour):"
        UserDefaults.standard.set(hour, forKey: "wakeUpHour")
    }
    
    @IBAction func minuteChangeHandler(_ sender: CircularSlider) {
        let minute = Int(sender.endPointValue)
        minuteLabel.text = minute < 10 ? "0\(minute)" : "\(minute)"
        UserDefaults.standard.set(minute, forKey: "wakeUpMinute")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
