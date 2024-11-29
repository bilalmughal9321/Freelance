//
//  AppCoordinator.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 03/11/2024.
//

import SwiftUI

class AppCoordinator: ObservableObject {
    
    // App navigation ke liye current view state
    @Published var currentView: AppView = .login
    
    // App ka navigation state (simple example mein ek enum se manage)
    enum AppView {
        case login
        case main
        case group
        case chat
        case settings
    }
    
    // App mein login aur logout ke states handle karna
    @Published var isLoggedIn: Bool = false
    
    init() {
        // Initial setup ya authentication check
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        // Placeholder logic: isko aap login state check karne ke liye customize kar sakte hain
        if isLoggedIn {
            currentView = .main
        } else {
            currentView = .login
        }
    }
    
    func navigate(to view: AppView) {
        currentView = view
    }
    
    func login() {
        // Login process, jaise user authenticated ho gaya to:
        isLoggedIn = true
        currentView = .main
    }
    
    func logout() {
        // Logout process
        isLoggedIn = false
        currentView = .login
    }
}

