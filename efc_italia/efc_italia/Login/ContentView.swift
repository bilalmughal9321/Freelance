//
//  ContentView.swift
//  efc_italia
//
//  Created by Bilal Mughal on 24/07/2024.
//

import SwiftUI

struct ContentView: View {
    @State var emailField: String = ""
    @State var pwdField: String = ""
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Spacer()
                
                Text("Sign In")
                    .font(.title)
                    .bold()
                
                ExtractedTextField(name: "Email", field: $emailField)
                
                ExtractedSecureField(name: "Password", field: $pwdField)
               
                NavigationLink {
                    RegistrationView()
                } label: {
                    AuthenticateBtn(name: "Sign In")
                }

                Spacer()
                
                
                NavigationLink {
                    RegistrationView()
                } label: {
                    HStack(spacing: 3) {
                        Text("Dont have an account? ")
                            .foregroundStyle(.black)
                            .font(.caption)
                        Text("Sign Up")
                            .foregroundStyle(.black)
                            .font(.footnote)
                            .bold()
                    }
                }
            }
            
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    ContentView()
}





