//
//  RegistrationViewController.swift
//  BankingApp
//
//  Created by Bilal Mughal on 24/11/2024.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white

    }
    
    
    @IBAction func loginTap(_ sender: Any) {
       
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    @IBAction func signUpTap(_ sender: Any) {
        
        guard emailField.text != "", passwordField.text != "" else {
            self.showAlert(title: "Error", message: "Enter credentials")
            return
        }
        
        Constant.email = emailField.text!
        Constant.password = passwordField.text!
        
        self.showAlert(title: "Success", message: "Registration successful")
        
    }
    
   

}
