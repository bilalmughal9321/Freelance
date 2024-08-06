//
//  ApiManager.swift
//  efc_italia
//
//  Created by Bilal Mughal on 24/07/2024.
//

import Foundation
import Alamofire

struct APIManager {
    let baseURL: String
    
    func request<T: Decodable>(endpoint: APIEndpoint, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        let url = endpoint.url(baseURL: baseURL)
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}
