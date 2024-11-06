//
//  TabView.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 02/11/2024.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var groupViewModel = GroupVM()
    @StateObject var chatViewModel = ChatVM()
    @StateObject var settingsViewModel = SettingsVM()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.black // Use UIColor to set the background color
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray // Change unselected item color
        UITabBar.appearance().tintColor = UIColor.blue 
    }
    
    
    var body: some View {
        TabView {
            Group{
//                GroupView(groupViewModel: groupViewModel)
//                    .tabItem {
//                        Label("Group", systemImage: "person.3")
//                    }
                
                ChatView()
                    .tabItem {
                        Label("Chat", systemImage: "message")
                    }
                
                SettingsView(settingsViewModel: settingsViewModel)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
      
        
    }
        
}


#Preview {
    MainTabView()
}
