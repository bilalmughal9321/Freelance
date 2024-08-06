//
//  SignInWebAuthnResponse.swift
//  PasskeyStoryoard
//
//  Created by Bilal Mughal on 17/07/2024.
//

import Foundation

struct SignInWebAuthnResponse: Codable {
    let challenge: String
    let timeout: Int
    let rpId: String
    let allowCredentials: [PublicKeyCredentialDescriptor]
    let userVerification: UserVerificationRequirement?  
}

struct PublicKeyCredentialDescriptor: Codable {
    let type: String
    let id: Int
    let transports: [AuthenticatorTransport]
}

struct AuthenticatorTransport: Codable {
    let usb: String
    let nfc: String
    let ble: String
    let hybrid: String
    let `internal`: String
}

enum UserVerificationRequirement: String, Codable {
    case required
    case preferred
    case doscouraged
}
