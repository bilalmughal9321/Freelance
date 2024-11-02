//
//  SettingsView.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 02/11/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsVM
    
    var body: some View {
        VStack{
            Text("Settings Screen")
                .font(.title)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsVM())
}
