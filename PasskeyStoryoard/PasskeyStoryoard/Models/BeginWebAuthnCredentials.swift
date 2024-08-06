//
//  BeginWebAuthnCredentials.swift
//  passkeyProject
//
//  Created by Bilal Mughal on 17/07/2024.
//

import Foundation


// MARK: - BeginWebAuthnRegistrationResponse/PublicKeyCredentialCreationOptions Model
struct BeginWebAuthnRegistrationResponse: Codable {
    let rp: Rp
    let timeout: Int
    let attestation: String
    let pubKeyCredParams: [PubKeyCredParam]
    let challenge: String
    let user: User
}
// MARK: - PubKeyCridParam
struct PubKeyCredParam: Codable {
    let type: String
    let alg: Int
}
// MARK: - Rp
struct Rp: Codable {
    let id, name: String
}
// MARK: User
struct User: Codable {
    let id, name, displayName: String
}
