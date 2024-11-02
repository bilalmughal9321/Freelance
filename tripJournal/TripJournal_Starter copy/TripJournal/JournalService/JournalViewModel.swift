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
    }
    
    // MARK:  # -------------------------- Edit / Delete / Get by id Trips --------------------------- # -
    
    func configureTrip(id: Int, param: [String: Any] = [:], method: HTTPMethod = .GET) async throws -> TripsModel? {
        
        do {
            let data = try await NetworkManager.shared.performRequest(
                method: method,
                urlString: "\(Constant.TRIPS)/\(id)",
                parameters: param,
                contentType: .json,
                headers: ["Authorization": "\(token?.tokenType ?? "") \(token?.accessToken ?? "")"]
            )
            if method == .GET {
                let decoder = JSONDecoder()
                let jsonModel = try decoder.decode(TripsModel.self, from: data)
                return jsonModel
            }
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
        return nil
    }
    
    // MARK:  # -------------------------- Create Trips --------------------------- # -
    
    func createTrip(param: [String: Any]) async throws {
        do {
            let _ = try await NetworkManager.shared.performRequest(
                method: .POST,
                urlString: "\(Constant.TRIPS)",
                parameters: param,
                contentType: .json,
                headers: ["Authorization": "\(token?.tokenType ?? "") \(token?.accessToken ?? "")"]
            )
        }
        catch {
            throw error
        }
    }
    
    // MARK:  # -------------------------- Create Events --------------------------- # -
    
    func createEvents(param: [String: Any]) async throws {
        do {
            let _ = try await NetworkManager.shared.performRequest(
                method: .POST,
                urlString: "\(Constant.EVENTS)",
                parameters: param,
                contentType: .json,
                headers: ["Authorization": "\(token?.tokenType ?? "") \(token?.accessToken ?? "")"]
            )
        }
        catch {
            throw error
        }
    }
    
    
    // MARK:  # -------------------------- Edit / Delete / Get by id Event --------------------------- # -
    
    func configureEvent(id: Int, param: [String: Any] = [:], method: HTTPMethod = .GET) async throws -> EventsModel? {
        
        do {
            let data = try await NetworkManager.shared.performRequest(
                method: method,
                urlString: "\(Constant.EVENTS)/\(id)",
                parameters: param,
                contentType: .json,
                headers: ["Authorization": "\(token?.tokenType ?? "") \(token?.accessToken ?? "")"]
            )
            if method == .GET {
                let decoder = JSONDecoder()
                let jsonModel = try decoder.decode(EventsModel.self, from: data)
                return jsonModel
            }
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
        return nil
    }
    
    // MARK:  # -------------------------- Upload Media --------------------------- # -
    
    func uploadMedia(param: [String: Any]) async throws {
        
        do {
            let _ = try await NetworkManager.shared.performRequest(
                method: .POST,
                urlString: "\(Constant.MEDIA)",
                parameters: param,
                contentType: .json,
                headers: ["Authorization": "\(token?.tokenType ?? "") \(token?.accessToken ?? "")"]
            )
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
        
    }
    
    // MARK:  # -------------------------- Delete Media --------------------------- # -
    
    func deleteMedia(id: Int) async throws {
        do {
            let _ = try await NetworkManager.shared.performRequest(
                method: .DELETE,
                urlString: "\(Constant.MEDIA)/\(id)",
                parameters: [:],
                contentType: .json,
                headers: ["Authorization": "\(token?.tokenType ?? "") \(token?.accessToken ?? "")"]
            )
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
    }
    
}


// MARK: - MODELS -


// MARK:  # -------------------------- Login / Registration Model --------------------------- # -

struct tokenModel: Codable {
    let accessToken: String
    let tokenType: String
    
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
    let events: [EventsModel]
    
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
        events = try container.decode([EventsModel].self, forKey: .events)
        
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

// MARK:  # -------------------------- Events Model --------------------------- # -

struct EventsModel: Codable, Hashable, Equatable, Identifiable {
    let name: String
    let date: Date
    let note: String?
    let location: LocationModel?
    let transitionFromPrevious: String?
    let id: Int
    let medias: [MediasModel]
    
    enum CodingKeys: String, CodingKey {
        case name
        case date
        case note
        case location
        case transitionFromPrevious = "transition_from_previous"
        case id
        case medias
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        note = try container.decodeIfPresent(String.self, forKey: .note)  // Optional note
        location = try container.decode(LocationModel.self, forKey: .location)
        transitionFromPrevious = try container.decodeIfPresent(String.self, forKey: .transitionFromPrevious) // Optional transition
        id = try container.decode(Int.self, forKey: .id)
        medias = try container.decode([MediasModel].self, forKey: .medias)
        
        let dateString = try container.decode(String.self, forKey: .date)
        
        guard let dateValue = EventsModel.dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .date,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
        
        date = dateValue
    }
}

// MARK:  # -------------------------- Location Model --------------------------- # -

struct LocationModel: Codable, Hashable, Equatable {
    let latitude: Double
    let longitude: Double
    let address: String
}

// MARK:  # -------------------------- Media Model --------------------------- # -

struct MediasModel: Codable, Hashable, Equatable, Identifiable {
    let caption: String
    let id: Int
    let url: String
}
