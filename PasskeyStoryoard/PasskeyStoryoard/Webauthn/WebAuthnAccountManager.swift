//
//  WebAuthnAccountManager.swift
//  passkeyProject
//
//  Created by Bilal Mughal on 17/07/2024.
//

import Foundation
import AuthenticationServices
import os
import Alamofire

private let domain = "df49-2601-2c7-4480-6e00-b5b-7dc-a469.ngrok-free.app/"
private let createUserApiEndpoints = "https://\(domain)signup"
private let signInApiEndpoints = "https://\(domain)authnticate"
private let registerBeginApiEndpoints = "https://\(domain)makeCredential"
private let signoutApiEndpoints = "https://\(domain)signout"
private let deleteCredentialApiEndpoints = "https://\(domain)deleteCredential"

extension NSNotification.Name {
    static let UserSignedIn = Notification.Name("UserSignedInNotification")
    static let PresentAlert1InSignInVC = Notification.Name("PresentAlert1InSignInVCNotification")
    static let PresentAlert2InSignInVC = Notification.Name("PresentAlert2InSignInVCNotification" )
    static let PresentAlertInCreateAccountVC = Notification.Name("PresentAlertInCreateAccountVCNotification")
    static let PresentASAuthorizationAlertInSignInVC = Notification.Name("PresentASAuthorizationAlertInSignInVC" )
    static let PresentSignOutUserAlert = Notification.Name("PresentSignOutUserAlertNotification")
    static let PresentDeleteUserErrorAlert = Notification.Name ("PresentDeleteUserErrorAlert")
}

class WebAuthnAccountManager: NSObject, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    private var anchor: ASPresentationAnchor?
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return anchor!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        let logger = Logger()
        switch authorization.credential {
        case let credentialRegistration as ASAuthorizationPlatformPublicKeyCredentialRegistration:
            logger.log("A new passkey has been registered")
            let credentialIDObjectBase64 = credentialRegistration.credentialID.base64EncodedString()
            let rawIDObject = credentialRegistration.credentialID.base64EncodedString()
            let clientDataJSONBase64 = credentialRegistration.rawClientDataJSON.base64EncodedString()
            guard let attestationObjectBase64 = credentialRegistration.rawAttestationObject?.base64EncodedString() else {
                logger.log("Error getting attestationobjectBase64" )
                return
            }
            
            let responseObject: [String: Any] = [
                "clientDataJSON": clientDataJSONBase64,
                "attestationObject": attestationObjectBase64
            ]
            
            let parameters: [String: Any] = [
                "id": credentialIDObjectBase64,
                "rawId": rawIDObject,
                "response": responseObject,
                "type": "public-key"
            ]
            
            Alamofire.request(registerBeginApiEndpoints, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
                switch response.response?.statusCode {
                case 200:
                    print("successful register")
                case .none:
                    print("response not found")
                    
                case .some(_):
                    print("Unknown response: \(String(describing: response.response?.statusCode))")
                }
            }
            
            
        case let credentialAssertion as ASAuthorizationPlatformPublicKeyCredentialAssertion:
            logger.log("A passkey was used to sign in")
            let credentialIDObject64 = credentialAssertion.credentialID.base64EncodedString()
            let rawIDObject = credentialAssertion.credentialID.base64EncodedString()
            let clientDataJSONBase64 = credentialAssertion.rawClientDataJSON.base64EncodedString()
            let authenticatorData = credentialAssertion.rawAuthenticatorData.base64EncodedData()
            let signature = credentialAssertion.signature.base64EncodedString()
            let userHandle = credentialAssertion.userID.base64EncodedString()
            
            let responseObject: [String: Any] = [
                "clientDataJSON": clientDataJSONBase64,
                "authenticatorData": authenticatorData,
                "signature": signature,
                "userHandle": userHandle
            ]
            
            let param: [String: Any] = [
                "id": credentialIDObject64,
                "rawId": rawIDObject,
                "response": responseObject,
                "type": "public-key"
            ]
            
            Alamofire.request(signInApiEndpoints, method: .get, parameters: param, encoding: JSONEncoding.default).responseData { responseData in
                switch responseData.response?.statusCode {
                case 200:
                    print("successfully signed in user using passkey")
                    self.didFinishSignIn()
                case .none:
                    print("Response not found")
                    self.presentASAuthorizationErrorAlert()
                case .some(_):
                    print("Unknown response found: \(String(describing: responseData.response?.statusCode))")
                    self.presentASAuthorizationErrorAlert()
                }
            }
            
        
        default:
            fatalError ("Received unknown authorization type")
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        let logger = Logger()
        
    
        
        guard let authorizationError = error as? ASAuthorizationError else {
            logger.error("unexpected authorization error \(error.localizedDescription)")
            self.presentASAuthorizationErrorAlert()
            return
        }
        if authorizationError.code == .canceled {
            logger.log("Request cancelled")
            
        }
        else {
            logger.log("Error \((error as NSError).userInfo)")
            self.presentASAuthorizationErrorAlert()
        }
    }
    
    func didFinishSignIn() {
        NotificationCenter.default.post(name: .UserSignedIn, object: nil)
    }
    
    func presentAlertInCreateVC() {
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

extension WebAuthnAccountManager {
    
    func registerUserCredential_WebAuthn (anchor: ASPresentationAnchor, username: String) {
        self.anchor = anchor
        let params: Parameters = [
            "username": username
        ]
        
        Alamofire.request("\(createUserApiEndpoints)", method: .get, parameters: params).responseData { responseData in
            
            switch responseData.response?.statusCode {
            case 200:
                print("Successful")
                Alamofire.request("\(registerBeginApiEndpoints)", method: .get).responseData { response in
                    if let data = response.data {
                        do{
                            let registerDataResponseDecoded = try JSONDecoder ().decode (BeginWebAuthnRegistrationResponse.self, from: data)
                            self.beginWebAuthnRegistration(response: registerDataResponseDecoded)
                        }
                        catch {
                            print("Error decoding BeginWebAuthnRegistrationResponse")
                        }
                    }
                }
            case 409:
                print("Conflict")
            case .some(_):
                print("Other response")
            case .none:
                print("No response")
                
            }
            
        }
        
    }
    
    
    
    func beginWebAuthnRegistration(response: BeginWebAuthnRegistrationResponse) {
        let challengeResponseString = response.challenge
        let userNameDecoded = response.user.name
        let userIDDecoded = response.user.id
        let userID = Data(userIDDecoded.utf8)
        
        guard let challengeBase64EncodedData = challengeResponseString.base64URLDecodedData() else {
        print("Error decoding challengeResponseString In to Data")
        return
        }
        
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: domain)
        let registrationRequest = publicKeyCredentialProvider.createCredentialRegistrationRequest(challenge: challengeBase64EncodedData, name:
        userNameDecoded, userID: userID)
        
        let authController = ASAuthorizationController(authorizationRequests: [registrationRequest])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
        
    }
    
    func getSignInResponse_Webauthn(anchor: ASPresentationAnchor) {
        self.anchor = anchor
        
        
        Alamofire.request("\(signInApiEndpoints)").responseData { responseData in
            switch responseData.response?.statusCode {
            case 200:
                print("Successful")
                if let data = responseData.data {
                    do {
                        let signInDataResponseDecoded = try JSONDecoder().decode(SignInWebAuthnResponse.self, from: data)
                        self.signInResponse(response: signInDataResponseDecoded)
                    }
                    catch {
                        print("error decoding signInResponse")
                    }
                }
            case 401:
                print("Unauthorize user - error 401")
                
                
            case .some(_):
                print("Unknown response: \(String(describing: responseData.response?.statusCode))")
            case .none:
                print("Response not found")
            }
        }
    }
    
    func signInResponse(response: SignInWebAuthnResponse) {
        let challenge = response.challenge
        guard let challengeBase64URLDecodedData = challenge.base64URLDecodedData() else {
            print("Error decoding challengeBase64URLDecodedData")
            return
        }
        
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: domain)
        let assertionRequest = publicKeyCredentialProvider.createCredentialAssertionRequest(challenge: challengeBase64URLDecodedData)
        
        let authController = ASAuthorizationController(authorizationRequests: [assertionRequest])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
        
    }
    
    func signOutWebauthnUser(completion: @escaping (Bool) -> Void) {
        Alamofire.request("\(signoutApiEndpoints)").responseData { responseData in
            switch responseData.response?.statusCode {
            case 200:
                print("Successfully signout user")
                completion(true)
                
            case .none:
                print("Respone not found")
                completion(false)
                
            case .some(_):
                print("Unknown response: \(String(describing: responseData.response?.statusCode))")
            }
        }
    }
    
    func deleteUserAccount(completion: @escaping (Bool) -> Void) {
        Alamofire.request("\(deleteCredentialApiEndpoints)").responseData { responseData in
            switch responseData.response?.statusCode {
            case 200:
                print("Successfully deleted user account")
                completion(true)
                
            case .none:
                print("Respone not found")
                completion(false)
                
            case .some(_):
                print("Unknown response: \(String(describing: responseData.response?.statusCode))")
            }
        }

    }
   
    
}

extension String {
    func base64URLDecodedData() -> Data? {
        var base64 = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let paddingLength = (4 - base64.count % 4) % 4
        base64 += String(repeating: "=", count: paddingLength)
        
        return Data(base64Encoded: base64)
    }
}
