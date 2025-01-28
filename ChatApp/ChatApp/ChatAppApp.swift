//
//  ChatAppApp.swift
//  ChatApp
//
//  Created by Bilal Mughal on 14/01/2025.
//

import SwiftUI

@main
struct ChatAppApp: App {
    
    @StateObject var themeModel = theme()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(themeModel)
        }
    }
}
