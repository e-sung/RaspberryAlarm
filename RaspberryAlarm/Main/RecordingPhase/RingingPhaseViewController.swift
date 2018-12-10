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
import MediaPlayer



class RingingPhaseViewController: UIViewController {

    var startDate: Date!
    private var alarmPlayer:AVAudioPlayer?
    private var volumeIncrementerTimer: Timer?
    // MARK: IBActions
    @IBAction private func snoozeButtonHandler(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToRecordingPhase", sender: nil)
    }
    
    @IBAction private func terminateButtonHandler(_ sender: UIButton) {
        HealthKitHelper.shared.saveSleepAnalysis(from: startDate)
        performSegue(withIdentifier: "unwindToCicularClock", sender: nil)
        guard let turnOffURL = UserDefaults.standard.url(forKey: URLsKeys[2]) else { return }
        URLSession.shared.dataTask(with: turnOffURL).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: 알람이 울릴 때 행해져야 할 일들
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = true // 핸드폰 안 꺼지게 하는 설정
        volumeIncrementerTimer = Timer.scheduledTimer(withTimeInterval: 10,
                                                      repeats: true,
                                                      block: { [weak self] _ in self?.incremntVolume()})
        setUpAlarmPlayer()
        startPlayingAlarm()
    }
    
    func setUpAlarmPlayer() {
        let path = Bundle.main.path(forResource: "alarm", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .defaultToSpeaker)
        alarmPlayer = try? AVAudioPlayer(contentsOf: url)
        alarmPlayer?.numberOfLoops = -1
        alarmPlayer?.volume = 0
    }
    
    func startPlayingAlarm() {
        setMasterVolume(value: 0.1, completion: { [weak self] in
            self?.alarmPlayer?.volume = 1
            self?.alarmPlayer?.play()
        })
    }
    
    @objc func incremntVolume() {
        let currentVolume = AVAudioSession.sharedInstance().outputVolume
        let incrementedVolue = currentVolume + 0.05
        setMasterVolume(value: incrementedVolue, completion: nil)
        if incrementedVolue >= 1 {
            volumeIncrementerTimer?.invalidate()
            volumeIncrementerTimer = nil
        }
    }

    // MARK: 다시 핸드폰 꺼질 수 있는 상태로 복귀
    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func setMasterVolume(value: Float, completion: (()->Void)?) {
        let volumeView = MPVolumeView()
        if let slider = volumeView.subviews.first as? UISlider
        {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                slider.value = value
                completion?()
            }
        }
    }
}



