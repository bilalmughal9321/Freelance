//
//  RegistrationVC.swift
//  SaraProject
//
//  Created by Bilal Mughal on 14/11/2024.
//

import UIKit

protocol signUpDelegate {
    func backScreen()
}

class RegistrationVC: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var delegate: signUpDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerTap(_ sender: Any) {
        
        guard emailField.text != "" else {return showAlert(title: "Error", message: "Email is missing")}
        
        guard passwordField.text != "" else {return showAlert(title: "Error", message: "Password is missing")}
        
        DBManager.shared.signUpUser(email: emailField.text!,
                                    password: passwordField.text!) {
            
            DispatchQueue.main.async {
                self.showAlert(title: "Alert", message: "User Created Successfully")
                
               
            }
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
