//
//  AppDelegate.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 11..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit
import MainKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if #available(iOS 12.0, *) {
            if userActivity.activityType == "StartRecordingIntent" {
                showRecordingPhase(on: application)
            }
        }
        return true
    }
    
    func showRecordingPhase(on application: UIApplication) {
        guard let rootVC = application.keyWindow?.rootViewController else { return }
        guard let navigationVC = rootVC as? UINavigationController else { return }
        navigationVC.popToRootViewController(animated: false)
        guard let topVC = navigationVC.topViewController as? CircularClockViewController else { return }
        topVC.performSegue(withIdentifier: "showRecordingPhase", sender: nil)
    }
}

