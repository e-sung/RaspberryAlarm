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

    private var player:AVPlayer?
    @IBAction private func snoozeButtonHandler(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToRecordingPhase", sender: nil)
    }
    
    @IBAction private func terminateButtonHandler(_ sender: UIButton) {
        let turnOffURL = UserDefaults.standard.url(forKey: URLsKeys[2])!
        URLSession.shared.dataTask(with: turnOffURL).resume()
        self.performSegue(withIdentifier: "unwindToAlarmList", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {return}
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem) // TODO : Increase Volume continuously
        player?.play()
    }
}
