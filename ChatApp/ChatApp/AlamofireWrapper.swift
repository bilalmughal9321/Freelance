//
//  AlamofireWrapper.swift
//  ChatApp
//
//  Created by Bilal Mughal on 31/01/2025.
//

import Foundation
import Alamofire

class AlamofireWrapper {
    
    // Base URL for your API
    static let baseURL = "http://157.230.151.253/first/api"
    
    // Singleton instance
    static let shared = AlamofireWrapper()
    
    private init() {}
    
    // MARK: - Generic Function for GET and POST Requests
    enum HTTPMethodType {
        case get, post
    }

    func request<T: Decodable, U: Encodable>(method: HTTPMethodType, endpoint: String, parameters: U? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        let url = "\(AlamofireWrapper.baseURL)\(endpoint)"
        
        var request: DataRequest
        
        switch method {
        case .get:
            request = AF.request(url, method: .get, parameters: parameters as! Parameters, encoding: URLEncoding.default)
        case .post:
            request = AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
        }
        
        request.validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
