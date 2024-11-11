//
//  SettingsView.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 02/11/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsVM
    @State private var isEditSheetPresented = false // State variable for sheet presentation
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile Image and Edit Button
            VStack {
                Button(action: {
                    isEditSheetPresented = true // Show the sheet when Edit is clicked
                }) {
                    Text("Edit")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
                .offset(x: -16)
                
                ZStack(alignment: .topTrailing) {
                    Image("profile_image") // Replace with your image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                
                // Name and Contact Information
                Text("Adrien")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("+33648359948")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            
            // Change Profile Photo Button
            Button(action: {
                // Change profile photo action
            }) {
                HStack {
                    Image(systemName: "camera")
                        .foregroundColor(.blue)
                    Text("Change profile photo")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
            }
            
            // Menu Buttons
            VStack(spacing: 10) {
                MenuButton(icon: "pencil", text: "My Weekly presentations")
                MenuButton(icon: "chart.bar", text: "My stats")
                MenuButton(icon: "bell", text: "Notifications")
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.top, 40)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isEditSheetPresented) {
            EditProfileView() // This is the view presented in the bottom sheet
        }
    }
}

// Define the MenuButton view
struct MenuButton: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
            Text(text)
                .foregroundColor(.white)
                .font(.headline)
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.7))
        .cornerRadius(20)
    }
}

// Define the EditProfileView as the bottom sheet content
struct EditProfileView: View {
    var body: some View {
        VStack {
            Text("Edit Profile")
                .font(.title)
                .foregroundStyle(.white)
                .padding()
            
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5))
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsVM())
}
