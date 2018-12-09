//
//  RingingPhaseViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 13..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit
import AVFoundation
import RAFoundation
import HealthKit
import HealthKitHelper


class RingingPhaseViewController: UIViewController {

    var startDate: Date!
    private var alarmPlayer:AVPlayer {
        let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3")!
        return AVPlayer(url: url)
    }
    // MARK: IBActions
    @IBAction private func snoozeButtonHandler(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToRecordingPhase", sender: nil)
    }
    
    @IBAction private func terminateButtonHandler(_ sender: UIButton) {
        let turnOffURL = UserDefaults.standard.url(forKey: URLsKeys[2])!
        URLSession.shared.dataTask(with: turnOffURL).resume()
        self.dismiss(animated: true, completion: nil)
        HealthKitHelper.shared.saveSleepAnalysis(from: startDate)
    }
    
    // MARK: 알람이 울릴 때 행해져야 할 일들
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = true // 핸드폰 안 꺼지게 하는 설정
        alarmPlayer.play()

    }
    
    // MARK: 다시 핸드폰 꺼질 수 있는 상태로 복귀
    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}
