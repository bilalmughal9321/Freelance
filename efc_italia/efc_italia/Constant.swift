//
//  Constant.swift
//  efc_italia
//
//  Created by Bilal Mughal on 24/07/2024.
//

import Foundation

struct Constant {
    
    static var baseUrl = "https://adm.paydis.app"
    
    enum APIEndpoint {
        case getUsers
        case login
        case updateUser
        
        var path: String {
            switch self {
            case .getUsers:
                return "api.php?action=get_users"
            case .login:
                return "api.php?action=login"
            case .updateUser:
                return "api.php?action=update_user"
            }
        }
        
        func url() -> URL? {
            return URL(string: Constant.baseUrl + path)
        }
    }
    
}
