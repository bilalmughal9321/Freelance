//
//  SecondViewController.swift
//  PasskeyStoryoard
//
//  Created by Bilal Mughal on 23/07/2024.
//

import UIKit
import AuthenticationServices
import SVProgressHUD
import testPackage

class SecondViewController: UIViewController, UITextFieldDelegate {

    let challengeData = "79748667086073"
    
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        
//       var webView = MediumWebView()
//        self.view.addSubview(webView)
//        webView.frame = self.view.bounds
//        webView.load()
        
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func loginTap(_ sender: Any) {
        
        Apis.generateChallenge(email: emailField.text!, type: .login) { response, code in
            guard code == 200 else {return}
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            if let resp = response as? [String: Any],
               let data = resp["data"] as? [String: Any],
               let challenge = data["passkey_challenge"] as? String{
                
                
                self.login(challenge: challenge)
//                self.statusMessage = resp["message"] as? String ?? ""
//
//                completion(email, data["passkey_challenge"] as? String ?? "")
                
            }
        }
        
    }
    
    @IBAction func signupTap(_ sender: Any) {
        
        guard emailField.text != "" else {return}
        
        emailField.resignFirstResponder()
        
        SVProgressHUD.show()
        
        Apis.generateChallenge(email: emailField.text!, type: .signup) { response, code in
            guard code == 200 else {return}
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            if let resp = response as? [String: Any],
               let data = resp["data"] as? [String: Any],
               let challenge = data["passkey_challenge"] as? String{
                
                
                self.registration(challenge: challenge,
                                  email: self.emailField.text!)
//                self.statusMessage = resp["message"] as? String ?? ""
//                
//                completion(email, data["passkey_challenge"] as? String ?? "")
                
            }
        }
        
    }
    

    func registration(challenge: String, email: String) {
        let challengeResponseString = challenge
        let userNameDecoded = "\(email.split(separator: "@")[0])"
        let userIDDecoded = UUID().uuidString
        let userID = Data(userIDDecoded.utf8)
        
        guard let challengeBase64EncodedData = challengeResponseString.base64URLDecodedData() else {
            print("Error decoding challengeResponseString into Data")
            return
        }
        
        // Ensure userID is 64 bytes as required
        let userUUID = UUID().uuidString
        let userIDData = userUUID.data(using: .utf8)!
        
        // Debugging logs
        print("Challenge Base64 Encoded Data: \(challengeBase64EncodedData)")
        print("User ID Data: \(userIDData)")

        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: "api-vault-qa.cinqtech.com")
        let registrationRequest = publicKeyCredentialProvider.createCredentialRegistrationRequest(challenge: challengeBase64EncodedData, name: userNameDecoded, userID: userIDData)
        
        let authController = ASAuthorizationController(authorizationRequests: [registrationRequest])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
    
    func login(challenge: String) {
        let challengeResponseString = challenge
        let userIDDecoded = UUID().uuidString
        
        guard let challengeBase64EncodedData = challengeResponseString.base64URLDecodedData() else {
            print("Error decoding challengeResponseString into Data")
            return
        }
        
        // Ensure userID is 64 bytes as required
        let userUUID = UUID().uuidString
        let userIDData = userUUID.data(using: .utf8)!
        
        // Debugging logs
        print("Challenge Base64 Encoded Data: \(challengeBase64EncodedData)")
        print("User ID Data: \(userIDData)")

        let platformProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: "api-vault-qa.cinqtech.com")
        let platformKeyRequest = platformProvider.createCredentialAssertionRequest(challenge: challengeBase64EncodedData)
        let authController = ASAuthorizationController(authorizationRequests: [platformKeyRequest])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }

}

extension SecondViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialRegistration {
            
            // Take steps to handle the registration.
            let credentialId = credential.credentialID.base64EncodedString()
            let attestationObject = credential.rawAttestationObject?.base64EncodedString()
            let clientDataJSON = credential.rawClientDataJSON.base64EncodedString()
            
            print("credentialId: ", credentialId)
            print("attestationObject: ", attestationObject)
            print("clientDataJSON: ", clientDataJSON)
            
        } else if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion {
            // Take steps to verify the challenge.
            
            let authenticatorData = credential.rawAuthenticatorData.base64EncodedString()
            let clientDataJSON = credential.rawClientDataJSON.base64EncodedString()
            let signature = credential.signature.base64EncodedString()
            let userID = credential.userID.base64EncodedString()
            
            print("authenticatorData: ", authenticatorData)
            print("clientDataJSON: ", clientDataJSON)
            print("signature: ", signature)
            print("userID: ", userID)
            
        }
        else {
            
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle the error
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


import Alamofire
//import SVProgressHUD

enum endpoints: String  {
    case login = "/auth/login"
    case signup = "/auth/signup"
    case generatePasskey = "/auth//passkey/generate/challenge"
    case loginVerifyPasskey = "/auth//passkey/verify/challenge"
    case RegisterVerifyPasskey = "/auth//passkey/verify/signup/challenge"
    case generateQr = "/auth/authenticator/generate"
    case AthenticateVerify = "/auth/authenticator/verify"
}

enum challenge_type: String  {
    case login = "signin"
    case signup = "signup"
}

class Apis {
    
    static func generateChallenge(email: String, type: challenge_type, completion: @escaping (Any?, Int) -> ()) {
        let param: Parameters = ["email": email, "passkeytype": type.rawValue]
        APIService.shared.apiCalling(endpoints: .generatePasskey, param: param, header: [:], method: .post, encoding: JSONEncoding.default, completion: completion)
    }
    
}


class APIService {
    static let shared = APIService()
    
    private init(){}
    
    private let baseURL = "https://kumele-backend.vercel.app/api"
    
    
    
    func apiCalling(endpoints: endpoints,
                    param: Parameters,
                    header: HTTPHeaders,
                    method: HTTPMethod,
                    encoding: ParameterEncoding,
                    completion: @escaping (Any?, Int) -> ()) {
        
        let apiUrl = baseURL + endpoints.rawValue
        
        guard self.isConnected() else {
            print("Network issue")
            return
        }
        
//        DispatchQueue.main.async {
//            SVProgressHUD.show()
//        }
        
        Alamofire.request(apiUrl, method: method, parameters: param, encoding: encoding, headers: header).responseJSON { response in
            
//            DispatchQueue.main.async {
//                SVProgressHUD.dismiss()
//            }
            
            switch response.result {
                
            case .success(let value):
                
                completion(value, response.response?.statusCode ?? 500)
                
            case .failure(let err):
                print(err)
                
            }
            
        }
        
    }
    
    //    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
    //        let url = "\(baseURL)/login"
    //        let parameters: [String: Any] = [
    //            "email": email,
    //            "password": password
    //        ]
    //
    //        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
    //            .validate(statusCode: 200..<300)
    //            .responseJSON { response in
    //                switch response.result {
    //                case .success:
    //                    completion(.success(()))
    //                case .failure(let error):
    //                    completion(.failure(error))
    //                }
    //            }
    //    }
    //}
    
    func isConnected() -> Bool{
        return NetworkReachabilityManager()!.isReachable
    }
}
