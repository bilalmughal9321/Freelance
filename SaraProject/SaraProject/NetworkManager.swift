//
//  NetworkManager.swift
//  SaraProject
//
//  Created by Bilal Mughal on 26/11/2024.
//

import Foundation
import UIKit


class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func fetchData(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
}
