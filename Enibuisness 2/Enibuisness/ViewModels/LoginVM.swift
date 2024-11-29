//
//  LoginVM.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 02/11/2024.
//

import Foundation
import SwiftUI

// MARK: - LoginViewModel
class LoginVM: ObservableObject {
    @Published var isLoggedIn = false

    func login() {
        // Login logic (dummy example)
        isLoggedIn = true
    }
}
