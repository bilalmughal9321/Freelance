//
//  ViewController.swift
//  PasskeyStoryoard
//
//  Created by Bilal Mughal on 17/07/2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var txtFieldRegistration: UITextField!
    
    @IBOutlet weak var txtFieldLogin: UITextField!
    
    
    lazy var textfield: UITextField = {
       let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var passwordField: UITextField = {
       let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()

    private var signInObserver: NSObjectProtocol?
    private var alertError1Observer: NSObjectProtocol?
    private var alertError2Observer: NSObjectProtocol?
    private var alertError3Observer: NSObjectProtocol?
    private var PresentASAuthorizationErrorObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        signInObserver = NotificationCenter.default.addObserver(forName: .UserSignedIn, object: nil, queue: nil, using: { _ in
            
        })
        
        alertError1Observer = NotificationCenter.default.addObserver(forName: .PresentAlertInCreateAccountVC, object: nil, queue: nil, using: { _ in
            
        })
        
        alertError2Observer = NotificationCenter.default.addObserver(forName: .PresentAlert1InSignInVC, object: nil, queue: nil, using: { _ in
            
        })
        
        alertError3Observer = NotificationCenter.default.addObserver(forName: .PresentAlert2InSignInVC, object: nil, queue: nil, using: { _ in
            
        })
        
        PresentASAuthorizationErrorObserver = NotificationCenter.default.addObserver(forName: .PresentASAuthorizationAlertInSignInVC, object: nil, queue: nil, using: { _ in
            
        })
        
    }
    
    @IBAction func txtFieldRegistrationTap(_ sender: Any) {
        
        guard let window = self.view.window else {return}
        
        guard txtFieldRegistration.text != "" else {return}
        
        (UIApplication.shared.delegate as? AppDelegate)?.webAuthnAccountManager.registerUserCredential_WebAuthn(anchor: window, username: txtFieldRegistration.text!)
    }
    
    @IBAction func txtFieldLoginTap(_ sender: Any) {
        
        guard let window = self.view.window else {return}
                
        (UIApplication.shared.delegate as? AppDelegate)?.webAuthnAccountManager.getSignInResponse_Webauthn(anchor: window)
        
    }
    
    @IBAction func logoutTap(_ sender: Any) {
        (UIApplication.shared.delegate as? AppDelegate)?.webAuthnAccountManager.signOutWebauthnUser(completion: { status in
            if status {
                print("###### signout success #######")
            }
        })
    }
    
    
    @IBAction func deleteTap(_ sender: Any) {
        (UIApplication.shared.delegate as? AppDelegate)?.webAuthnAccountManager.deleteUserAccount(completion: { status in
            if status {
                print("###### deleted success #######")
            }
        })
    }
    
    
    func didFinishSignIn() {
//        NotificationCenter.default.post(name: .UserSignedIn, object: nil)
        
        
        
    }
    
    func PresentAlertInCreateVC() {
        NotificationCenter.default.post(name: .PresentAlertInCreateAccountVC, object: nil)
    }
    
    func presentAlert1InSignInVC() {
        NotificationCenter.default.post(name: .PresentAlert1InSignInVC, object: nil)
    }
    
    func presentAlert2InSignInVC() {
        NotificationCenter.default.post(name: .PresentAlert2InSignInVC, object: nil)
    }
    
    func presentASAuthorizationErrorAlert() {
        NotificationCenter.default.post(name: .PresentASAuthorizationAlertInSignInVC, object: nil)
    }

}

