//
//  SendMoneyViewController.swift
//  BankingApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class SendMoneyViewController: UIViewController {
    
   
    @IBOutlet weak var amountField: UITextField!
    
    @IBOutlet weak var availableLbl: UILabel!
    
    
    @IBOutlet weak var receiverField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountField.delegate = self
        
        amountField.addTarget(self, action: #selector(amountFieldDidChange), for: .editingChanged)
        
        availableLbl.text = "Available balance: \(Constant.available_balance) AED"
        
    }
    
    @objc func amountFieldDidChange() {
        
        if let value = amountField.text, !value.isEmpty {
            if let amount = Int(value) {
                print(amount)
                
                if amount > Constant.available_balance {
                    amountField.text?.removeLast()
                    showAlert(title: "Error", message: "Amount should not be greater than available balance")
                    
                    
                }
                
            }
        }
        
    }
    
    
    
    @IBAction func sendTap(_ sender: Any) {
        
        guard receiverField.text != "" else {
            return showAlert(title: "Error", message: "Please enter receiver's name")
        }
        
        if amountField.text?.isEmpty ?? true {
            return showAlert(title: "Error", message: "Please enter amount")
        }
        
        if let amount = Int(amountField.text!) {
            Constant.available_balance -= amount
        }
        
        availableLbl.text = "Available balance: \(Constant.available_balance) AED"
        
        TransactionHistoryViewController.data.append(transaction(transaction_label: "Amount Sent to \(receiverField.text!)", amount: "\(amountField.text!) AED", type: .debit, date: "24 Nov, 2024"))
        
        showAlert(title: "Alert", message: "Amount has been sent")
        
        scheduleNotification()
    }
    
    func scheduleNotification() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = "\(amountField.text!) AED has been sent to \(receiverField.text!)"
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


extension SendMoneyViewController: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        if let value = textField.text, !value.isEmpty {
//            
//            if let amount = Int(value) {
//                if amount < Constant.available_balance {
//                    return true
//                }
//                else {
//                    self.showAlert(title: "Error", message: "Amount should not be greater than available balance")
//                    return false
//                }
//            }
//            else {
//                return false
//            }
//            
//        }
//        else {
//            
//            let allowedCharacterSet = CharacterSet.decimalDigits
//            let characterSet = CharacterSet(charactersIn: string)
//            return allowedCharacterSet.isSuperset(of: characterSet)
//        }
//    }
//    
}


