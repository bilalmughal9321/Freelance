//
//  SettingsView.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 02/11/2024.
//

import SwiftUI

enum menuType {
    case dob
    case number
    case email
    case profession
    case compony
    case location
    case website
    case presentation
}

struct SettingsView: View {
    @ObservedObject var settingsViewModel: SettingsVM
    @State private var isEditSheetPresented = false // State variable for sheet presentation
    
    var body: some View {
        VStack(spacing: 10) {
            // Profile Image and Edit Button
            VStack {
                Button(action: {
//                   ` isEditSheetPresented = true // Show the sheet when Edit is clicked
                }) {
                    Text("Log out")
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
                
                Button(action: {
                    // Change profile photo action
                }) {
                    HStack {
                        Image(systemName: "camera")
                            .foregroundColor(.blue)
                        Text("Set New Photo")
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                }
                
//                Text("Adrien")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                Text("+33648359948")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            
            // Change Profile Photo Button
           
            
            // Menu Buttons
//            ScrollView{
            VStack(spacing: 10) {
                
                    MenuDouble(icon: "pencil", text: "Adrien", firstName: "Adrien", lastName: "Dupont")
                    MenuButton(menuNature: .dob, text: "Date of birth")
                        .padding(.top)
                    
                    MenuButton(menuNature: .number, text: "Phone number")
                        .padding(.top)
                    
                    MenuButton(menuNature: .email, text: "Email")
                    
                    MenuButton(menuNature: .profession, text: "Profession")
                    
                    MenuButton(menuNature: .compony, text: "Company")
                    
                    MenuButton(menuNature: .location, text: "Location")
                    
                    MenuButton(menuNature: .website, text: "Website")
                    
                    MenuButton(menuNature: .presentation, text: "My weekly presentations")
                    //                MenuButton(icon: "pencil", text: "My Weekly presentations")
                    //                MenuButton(icon: "chart.bar", text: "My stats")
                    //                MenuButton(icon: "bell", text: "Notifications")
                }
//            }
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

struct MenuDouble: View {
    var icon: String
    var text: String
    
    @State var firstName: String
    @State var lastName: String
    
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {

                TextField("First Name", text: $firstName)
                    .foregroundColor(.white)
                    .font(.headline)

                Spacer()
            }
            
            Divider().background(Color.white)
            
            HStack {

                TextField("Last Name", text: $lastName)
                    .foregroundColor(.white)
                    .font(.headline)
                    
                Spacer()
            }
        }
     
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.menuBackgroundColor)
        .cornerRadius(20)
    }
}

// Define the MenuButton view
struct MenuButton: View {
    
    var menuNature: menuType? = nil
    
    var text: String
    
    var body: some View {
        Button {
            
        } label: {
            HStack {
                Text(text)
                    .foregroundColor(.white)
                    .font(.headline)
                
                Spacer()
                switch menuNature {
                    
                case .dob:
                    Text("Add")
                        .foregroundStyle(.gray.opacity(0.8))
                        .font(.headline)
                    
                case .number:
                    Text("+380 68 423 76")
                        .foregroundStyle(.gray.opacity(0.8))
                        .font(.headline)
                    
                case .email:
                    Text("adrienborg@outlook.com")
                        .foregroundStyle(.gray.opacity(0.8))
                        .font(.headline)
                        .allowsHitTesting(false)
                        .accentColor(.gray.opacity(0.8))
                        .underline()
                    
                case .profession:
                    Text("Buisness developer")
                        .foregroundStyle(.gray.opacity(0.8))
                        .font(.headline)
                    
                case .compony:
                    Text("ENUBUSINESS")
                        .foregroundStyle(.gray.opacity(0.8))
                        .font(.headline)
                    
                case .location:
                    Text("Paris")
                        .foregroundStyle(.gray.opacity(0.8))
                        .font(.headline)
                    
                default:
                    EmptyView()
                }
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray.opacity(0.5))
                    
                    
                
            }
        }
        
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color(hex: "242424"))
        .cornerRadius(12)
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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: Double
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (1, Double((int >> 8) * 17) / 255.0, Double((int >> 4 & 0xF) * 17) / 255.0, Double((int & 0xF) * 17) / 255.0)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (1, Double((int >> 16) & 0xFF) / 255.0, Double((int >> 8) & 0xFF) / 255.0, Double(int & 0xFF) / 255.0)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (Double((int >> 24) & 0xFF) / 255.0, Double((int >> 16) & 0xFF) / 255.0, Double((int >> 8) & 0xFF) / 255.0, Double(int & 0xFF) / 255.0)
        default:
            (a, r, g, b) = (1, 1, 1, 0) // Fallback to clear color
        }
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}

extension Color {
    
    static var menuBackgroundColor: Color {
        .init(hex: "#242424")
    }
    
}
