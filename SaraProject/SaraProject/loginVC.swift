//
//  loginVC.swift
//  SaraProject
//
//  Created by Bilal Mughal on 14/11/2024.
//

import UIKit


class loginVC: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!{
        didSet{
            emailField.text = "bilal@gmail.com"
        }
    }
    
    @IBOutlet weak var passwordField: UITextField!{
        didSet{
            passwordField.text = "bilal123"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "register" {
            let _ = segue.destination as! RegistrationVC
        }
    }
    
    
    @IBAction func loginTap(_ sender: Any) {
        
        guard emailField.text != "" else {return showAlert(title: "Error", message: "Email is missing")}
        
        guard passwordField.text != "" else {return showAlert(title: "Error", message: "Password is missing")}
        
        DBManager.shared.loginUser(email: emailField.text!,
                                   password: passwordField.text!) { userId in
            DBManager.shared.userId = userId
            DBManager.shared.email = self.emailField.text!
            
            DispatchQueue.main.async {
//                self.showAlert(title: "Alert", message: "User login successfully")
            }
            self.performSegue(withIdentifier: "painting", sender: sender)
        }
        
        
        
    }
    
    
    
    @IBAction func registrationTap(_ sender: Any) {
        
        self.performSegue(withIdentifier: "register", sender: sender)
        
    }
    
  
}

extension ViewController: signUpDelegate {
    
    func backScreen() {}
    
}
