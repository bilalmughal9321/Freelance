//
//  PaymentVC.swift
//  TicketBookinApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit
import UserNotifications

class PaymentVC: UIViewController {

    var selectMovie: Movies!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func payTap(_ sender: Any) {
        scheduleNotification()
        
        selectMovie.selelctedData = Date()
        
        HistoryVC.movies.append(selectMovie)
    }
    
  
    func scheduleNotification() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = "Thank you for payment your movie has been booked"
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

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
