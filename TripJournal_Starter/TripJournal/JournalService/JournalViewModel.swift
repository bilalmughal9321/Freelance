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
    
    
    //MARK: - APIS -
    
    
    // MARK:  # -------------------------- Logout --------------------------- # -
    
    
    func logOut() {
        self.token = nil
        self.isAuthenticated = false
    }
    
    // MARK:  # -------------------------- Login / Registration --------------------------- # -
    
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
    
    // MARK:  # -------------------------- Get Trips / Read Trips --------------------------- # -
    
    func getTrips() async throws -> [TripsModel]{
        do {
            let data = try await NetworkManager.shared.performRequest(
                method: .GET,
                urlString: Constant.TRIPS,
                parameters: [:],
                contentType: .json,
                headers: ["Authorization": "\(token?.tokenType ?? "") \(token?.accessToken ?? "")"]
            )
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
            let decoder = JSONDecoder()
            let jsonModel = try decoder.decode([TripsModel].self, from: data)
            return jsonModel
        }
        catch {
            let errResponse = (error as? NetworkResponseError)?.responseBody ?? ""
            if let jsonData = errResponse.data(using: .utf8) {
                let decoder = JSONDecoder()
                let errModel = try decoder.decode(ErrorResponse.self, from: jsonData)
                print(errModel.detail)
                DispatchQueue.main.async {
                    self.Error = errModel.detail
                }
            }
            throw error
        }
        //        return []
    }
    
    func updateTrip(id: Int) async throws {
        
        
        
        
        do {
            let data = try await NetworkManager.shared.performRequest(
                method: .PUT,
                urlString: "\(Constant.TRIPS)/\(id)",
                parameters: [:],
                contentType: .json,
                headers: ["Authorization": "\(token?.tokenType ?? "") \(token?.accessToken ?? "")"]
            )
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
            let decoder = JSONDecoder()
            let jsonModel = try decoder.decode([TripsModel].self, from: data)
//            return jsonModel
        }
        catch {}
    }
    
}


// MARK: - MODELS -


// MARK:  # -------------------------- Login / Registration Model --------------------------- # -

/// TOKEN / REGISTRATION
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


// MARK:  # -------------------------- Trips List Model --------------------------- # -

struct TripsModel: Codable, Hashable, Identifiable {
    
    let name: String
    let startDate: Date
    let endDate: Date
    let id: Int
    let events: [Events]
    
    enum CodingKeys: String, CodingKey {
        case name
        case startDate = "start_date"
        case endDate = "end_date"
        case id
        case events
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        events = try container.decode([Events].self, forKey: .events)
        
        // Decode date strings to Date objects
        let startDateString = try container.decode(String.self, forKey: .startDate)
        let endDateString = try container.decode(String.self, forKey: .endDate)
        
        guard let startDateValue = TripsModel.dateFormatter.date(from: startDateString),
              let endDateValue = TripsModel.dateFormatter.date(from: endDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .startDate,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
        startDate = startDateValue
        endDate = endDateValue
    }
    
    static func == (lhs: TripsModel, rhs: TripsModel) -> Bool {
        return lhs.name == rhs.name &&
        lhs.startDate == rhs.startDate &&
        lhs.endDate == rhs.endDate &&
        lhs.id == rhs.id &&
        lhs.events == rhs.events
    }
}

struct Events: Codable, Hashable, Equatable {
    // Define properties for events if needed
}
