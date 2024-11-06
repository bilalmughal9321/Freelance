//
//  ContentView.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 02/11/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var loginViewModel = LoginVM()
    @StateObject private var groupVM = GroupVM()
    @StateObject private var chatVM = ChatVM()
    @StateObject private var settingVM = SettingsVM()

    var body: some View {
        VStack {
            switch coordinator.currentView {
            case .login:
                LoginView(loginViewModel: loginViewModel)
                    .environmentObject(coordinator)
            case .main:
                MainTabView()
                    .environmentObject(coordinator)
            case .group:
                GroupView(groupViewModel: groupVM)
                    .environmentObject(coordinator)
            case .chat:
                ChatView()
                    .environmentObject(coordinator)
            case .settings:
                SettingsView(settingsViewModel: settingVM)
                    .environmentObject(coordinator)
            }
        }
    }
}

#Preview {
    ContentView()
}
