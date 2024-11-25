//
//  ResultVC.swift
//  GameProject
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class ResultVC: UIViewController {
    var score: Int = 0
    var totalQuestions: Int = 0

    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Result"
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        resultLabel.text = "You scored \(score) out of \(totalQuestions)"
        notification()
    }
    
    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func notification() {
            let content = UNMutableNotificationContent()
            content.title = "Result"
            content.body = "You scored \(score) out of \(totalQuestions)"
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)

            let request = UNNotificationRequest(identifier: "notificationIdentifier", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully")
                }
            }
        }
}

