//
//  RegistrationView.swift
//  efc_italia
//
//  Created by Bilal Mughal on 24/07/2024.
//

import SwiftUI

struct RegistrationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var phone: String = ""
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Text("Sign Up")
                .font(.title)
                .bold()
            
            ExtractedTextField(name: "First Name", field: $firstname)
            ExtractedTextField(name: "Last Name", field: $lastname)
            ExtractedTextField(name: "Phone", field: $phone)
            ExtractedTextField(name: "Email", field: $email)
            ExtractedSecureField(name: "Password", field: $password)
            
            Button(action: {
                dismiss()
            }, label: {
                AuthenticateBtn(name: "Sign Up")
            })
            
            Spacer()
            
            Button(action: {
                dismiss()
            }, label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                        .foregroundStyle(.black)
                        .font(.caption)
                    Text("Sign Up")
                        .foregroundStyle(.black)
                        .font(.footnote)
                    .bold()
                }
            })
            
            
                
        }
        
        .padding(.horizontal, 20)
    }
}

#Preview {
    RegistrationView()
}
