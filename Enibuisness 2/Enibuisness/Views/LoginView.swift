//
//  LoginView.swift
//  Enibuisness
//
//  Created by Bilal Mughal on 02/11/2024.
//

import SwiftUI

// MARK: - LoginView
struct LoginView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    @ObservedObject var loginViewModel: LoginVM

    @State var phoneCode: String = ""
        @State var number: String = ""
        
        var body: some View {
            VStack {
                
                Spacer()
                
                VStack(spacing: 10) {
                    Image(systemName: "globe")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.tint)
                    Text("Your Phone")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                    
                    Text("Please confirm your country code and enter your phone number")
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    Divider().background(.white)
                        .opacity(0.2)
                    
                    HStack{
                        
                        TextField("", text: $phoneCode, prompt: Text("Code").foregroundColor(.gray.opacity(0.7)))
                            .foregroundStyle(.white)
                            .frame(maxWidth: 60, maxHeight: 30)
                            .multilineTextAlignment(.center)
                        
                        Divider().background(.white)
                            .frame(maxHeight: 30).opacity(0.3)
                        
                        TextField("Phone Number", text: $number, prompt: Text("Phone Number").foregroundColor(.gray.opacity(0.7)))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: 30)
                        
                    }
                    
                    Divider().background(.white).opacity(0.3)
                    
                }
                .padding()
                
                Spacer()
                
                Button {
                    coordinator.navigate(to: .main)
                } label: {
                    Text("Confirm")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .foregroundStyle(.white)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.primary))
                        .padding([.bottom, .horizontal])
                        
                        
                }
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
        }

}

#Preview {
    LoginView(loginViewModel: LoginVM())
}
