//
//  NetworkManager.swift
//  TripJournal
//


import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
}

enum ContentType {
    case urlEncoded
    case json
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case serverError(URLResponse?)
    case decodingError(Error)
}

struct NetworkManager {
    static let shared = NetworkManager()
    
    // Function to handle network requests
    func performRequest(
        method: HTTPMethod,
        urlString: String,
        parameters: [String: Any]? = nil,
        contentType: ContentType = .json,
        headers: [String: String]? = nil
    ) async throws -> Data {
        
        // Create URL components
        guard var urlComponents = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        // For GET requests, append parameters to the URL query
        if method == .GET, let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        // Create the URL request
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Add headers
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // For POST requests, add parameters in the body
        if method == .POST, let parameters = parameters {
            switch contentType {
            case .urlEncoded:
                let encodedParameters = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                request.httpBody = encodedParameters.data(using: .utf8)
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
            case .json:
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        
        // Perform the network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for server errors
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            let responseBody = String(data: data, encoding: .utf8) ?? "No response body"
            throw NetworkResponseError(statusCode: httpResponse.statusCode, responseBody: responseBody)
        }
        
        return data
    }
}

struct NetworkResponseError: Error {
    let statusCode: Int
    let responseBody: String
}
