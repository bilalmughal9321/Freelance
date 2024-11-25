//
//  loginVC.swift
//  SaraProject
//
//  Created by Bilal Mughal on 14/11/2024.
//

import UIKit

class LoadingAnimationView: UIActivityIndicatorView {}


class loginVC: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!{
        didSet{
            emailField.text = ""
        }
    }
    
    @IBOutlet weak var passwordField: UITextField!{
        didSet{
            passwordField.text = ""
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
        
        startLoading()
        
        DBManager.shared.loginUser(email: emailField.text!,
                                   password: passwordField.text!) { userId in
            DBManager.shared.userId = userId
            DBManager.shared.email = self.emailField.text!
            
            self.stopLoading()
            
            DispatchQueue.main.async {
                
//                self.showAlert(title: "Alert", message: "User login successfully")
            }
            self.performSegue(withIdentifier: "PaintingViewController", sender: sender)
        } err: { error in
            DispatchQueue.main.async {
                self.stopLoading()
                
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
            
        }
        
        
        
    }
    
    
    
    @IBAction func registrationTap(_ sender: Any) {
        
        self.performSegue(withIdentifier: "register", sender: sender)
        
    }
    
  
}

extension ViewController: signUpDelegate {
    
    func backScreen() {}
    
}


extension UIViewController {
    
    func startLoading() {
        
        let loading = LoadingAnimationView()
        loading.color = .white
        loading.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(loading)
        
        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loading.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            loading.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1)
        ])
        
        loading.startAnimating()
        
    }
    
    func stopLoading() {
        
        for _views in self.view.subviews {
            if _views is LoadingAnimationView {
                _views.removeFromSuperview()
            }
        }
        
    }
    
}
