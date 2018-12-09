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
    private var alarmPlayer:AVAudioPlayer?
    // MARK: IBActions
    @IBAction private func snoozeButtonHandler(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToRecordingPhase", sender: nil)
    }
    
    @IBAction private func terminateButtonHandler(_ sender: UIButton) {
        HealthKitHelper.shared.saveSleepAnalysis(from: startDate)
        self.dismiss(animated: true, completion: {
            guard let turnOffURL = UserDefaults.standard.url(forKey: URLsKeys[2]) else { return }
            URLSession.shared.dataTask(with: turnOffURL).resume()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAlarmPlayer()
        alarmPlayer?.play()
    }
    
    // MARK: 알람이 울릴 때 행해져야 할 일들
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = true // 핸드폰 안 꺼지게 하는 설정
    }
    
    func setUpAlarmPlayer() {
        let path = Bundle.main.path(forResource: "alarm", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        alarmPlayer = try? AVAudioPlayer(contentsOf: url)
    }

    
    // MARK: 다시 핸드폰 꺼질 수 있는 상태로 복귀
    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}
