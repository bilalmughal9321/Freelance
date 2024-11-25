//
//  LoginViewController.swift
//  BankingApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white

    }
    
    
    @IBAction func loginTap(_ sender: Any) {
        guard emailField.text == "khalfan@gmail.com", passwordField.text == "khalfan" else {
            self.showAlert(title: "Error", message: "Invalid credentials")
            return
        }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = sb.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
            navigationController?.pushViewController(dashboardVC, animated: false)
        }
        
        
        
    }
    
    
   

    
}


extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
