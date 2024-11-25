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
        guard emailField.text == Constant.email, passwordField.text == Constant.password else {
            self.showAlert(title: "Error", message: "Invalid credentials")
            return
        }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = sb.instantiateViewController(withIdentifier: "DashboardVC") as? UITabBarController {
            navigationController?.pushViewController(dashboardVC, animated: false)
        }
        
        
        
        
    }
    
    
    @IBAction func signUpTap(_ sender: Any) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let dashboardVC = sb.instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController {
            navigationController?.pushViewController(dashboardVC, animated: true)
        }
        
    }
    
   

    
}

