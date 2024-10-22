//
//  JournalViewModel.swift
//  TripJournal
//
//  Created by Bilal Mughal on 22/10/2024.
//

import Foundation
import SwiftUI

class JournalViewModel: ObservableObject {
    
    @Published var token: Token? = nil
    @Published var isAuthenticated = false
    @Published var Error = ""
    
    func authenticate(username: String, password: String, isRegister: Bool) async throws {
        
        var parameters = [
            "username": username,
            "password": password
        ]
        
        if !isRegister { parameters["grant_type"] = "" }
        
        do {
            let data = try await NetworkManager.shared.performRequest(
                method: .POST,
                urlString: isRegister ? Constant.REGISTER_URL : Constant.TOKEN_URL,
                parameters: parameters,
                contentType: isRegister ? .json : .urlEncoded
            )
            
            let decoder = JSONDecoder()
            let authResponse = try decoder.decode(tokenModel.self, from: data)
            print("\(isRegister ? "Register" : "Login") successful: \(authResponse)")
            
            DispatchQueue.main.async {
                self.token = Token(accessToken: authResponse.accessToken, tokenType: authResponse.tokenType)
                self.isAuthenticated = true
                self.Error = ""
            }
        } catch {
            let errResponse = (error as? NetworkResponseError)?.responseBody ?? ""
            if let jsonData = errResponse.data(using: .utf8) {
                let decoder = JSONDecoder()
                let errModel = try decoder.decode(ErrorResponse.self, from: jsonData)
                print(errModel.detail)
                DispatchQueue.main.async {
                    self.Error = errModel.detail
                }
            }
        }


    }
    
}


// MARK: MODELS -

struct tokenModel: Codable {
    let accessToken: String
    let tokenType: String
    
    // Map keys to different variable names using CodingKeys if the key names are different from the property names
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}

struct ErrorResponse: Codable {
    let detail: String
}
