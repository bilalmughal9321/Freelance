//
//  Constant.swift
//  BankingApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import Foundation
import UIKit


struct Constant {
    
    static var available_balance = 100000
    
    static var email = "abdullah@gmail.com"
    static var password = "abdullah"
    
    
    
}


extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
