//
//  RingingPhaseViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 13..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit

class RingingPhaseViewController: UIViewController {

    var snoozeAmount:Int!
    
    @IBAction func snoozeButtonHandler(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToRecordingPhase", sender: Phase.snooze)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? RecordingPhaseViewController {
            nextVC.phase = sender as! Phase
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
