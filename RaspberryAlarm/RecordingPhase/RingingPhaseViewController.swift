//
//  RingingPhaseViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 13..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit
import AVFoundation
class RingingPhaseViewController: UIViewController {

    var snoozeAmount:Int!
    var player:AVPlayer?
    @IBAction func snoozeButtonHandler(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToRecordingPhase", sender: Phase.snooze)
    }
    
    @IBAction func terminateButtonHandler(_ sender: UIButton) {
//        let alarmTerminationNoti = Notification(name: .init("AlarmTerminated"))
        self.performSegue(withIdentifier: "unwindToAlarmList", sender: nil)
//        NotificationCenter.default.post(alarmTerminationNoti)
        let url = URL(string: "http://192.168.0.20:3030")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? RecordingPhaseViewController {
            nextVC.phase = sender as! Phase
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let recorderTerminatedNoti = Notification(name: .init("RecorderTerminated"))
//        NotificationCenter.default.addObserver(forName: recorderTerminatedNoti.name , object: nil, queue: nil) { (noti) in
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
            print("url wasn't generated")
            return
        }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem) // TODO : Increase Volume continuously
        player?.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
