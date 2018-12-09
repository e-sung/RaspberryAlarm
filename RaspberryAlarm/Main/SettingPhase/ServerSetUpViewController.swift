//
//  ServerSetUpViewController.swift
//  RaspberryAlarm
//
//  Created by 류성두 on 2017. 11. 22..
//  Copyright © 2017년 류성두. All rights reserved.
//

import UIKit
import RAFoundation

class ServerSetUpViewController: UIViewController {
    
    @IBOutlet var textFields: [UITextField]!
    @IBAction func confirmButtonHandler(_ sender: UIBarButtonItem) {
        if allUserInputsAreValidURL{
            save(urls, with: URLsKeys, on: UserDefaults.standard)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonHandler(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    private func save(_ urls:[URL?], with keys:[String], on userDefaults:UserDefaults){
        for i in 0..<urls.count{
            userDefaults.set(urls[i], forKey: keys[i])
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.url(forKey: URLsKeys[0]) != nil {
            textFields[0].text = "\(UserDefaults.standard.url(forKey: URLsKeys[0])!)"
            textFields[1].text = parseRelative(url: UserDefaults.standard.url(forKey: URLsKeys[1])!)
            textFields[2].text = parseRelative(url: UserDefaults.standard.url(forKey: URLsKeys[2])!)
        }
    }
    
    func parseRelative(url:URL)->String{
        return String("\(url)".split(separator: " ")[0])
    }
}

extension ServerSetUpViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: Validations
extension ServerSetUpViewController{
    private var allFormsAreFilled:Bool{
        get{
            for tf in textFields{
                if tf.text == nil { return false }
            }
            return true
        }
    }
    
    var allUserInputsAreValidURL:Bool{
        get{
            if hostURL == nil {
                alert(msg: "서버 주소가 이상합니다")
                return false
            }else if onURL == nil{
                alert(msg: "켜기 주소가 이상합니다")
                return false
            }else if offURL == nil{
                alert(msg: "끄기 주소가 이상합니다")
                return false
            }
            return true
        }
    }
}

// MARK: URLs
extension ServerSetUpViewController{
    private var urls:[URL?]{
        return [hostURL,onURL,offURL]
    }
    private var hostURL:URL?{
        get{
            return URL(string: textFields[0].text!)
        }
    }
    private var onURL:URL?{
        get{
            return URL(string: textFields[1].text!, relativeTo: hostURL)
        }
    }
    private var offURL:URL?{
        get{
            return URL(string: textFields[2].text!, relativeTo: hostURL)
        }
    }
}
