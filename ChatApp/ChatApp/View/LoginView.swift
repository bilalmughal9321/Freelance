//
//  LoginView.swift
//  ChatApp
//
//  Created by Bilal Mughal on 28/01/2025.
//

import Foundation
import SwiftUI
import FloatingLabelTextFieldSwiftUI

struct LoginView: View {
    
    @EnvironmentObject var themeModel: theme
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var number: String = ""
    @State private var password: String = ""
    
    @FocusState private var nameIsFocused: Bool
    
    @State private var isPasswordShow: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
//    let gradientColor = ColorClass.getThemGradientColor(theme: themeModel.themeApp == .red ? .red : .blue)
    
    
    var body: some View {
       
        ZStack {
            ColorClass.getThemGradientColor(theme: themeModel.themeApp)
                .edgesIgnoringSafeArea([.top, .leading, .trailing])
            
            VStack(alignment: .leading) {
                HStack(spacing: 25){
                    
                    Button {presentationMode.wrappedValue.dismiss()} label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 12, height: 20)
                            .foregroundStyle(.white)
                            .bold()
                    }
                    
                    
                    Text("Login")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .bold()
                        .frame(maxWidth: 100, alignment: .leading)
                    Spacer()
                    
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.gray)
                       
               
                    
                }
                .padding(.horizontal, 20)
                
//                ZStack {
                VStack{
                    ScrollView {
                        
                        
                        
                        FloatingLabelTextField($email, placeholder: "Email")
                            .addValidation(.init(condition: email.isValid(.email),
                                                 errorMessage: "Invalid Email"))
                            
//                            .isShowError(true)
                            .floatingStyle(ThemeTextFieldStyle(themeColor: themeModel.themeApp))
                            .keyboardType(.emailAddress)
                            .frame(height: 70)
                            .padding(.horizontal)
                            .padding(.top, 100)
                            
                        
                        FloatingLabelTextField($password, placeholder: "Password")
//                            .addValidation(
//                                .init(
//                                    condition: password.count >= 7,
//                                    errorMessage: "Minimum two character long"
//                                )
//                            )
                            .isShowError(password.count >= 7 ? false : true)
                            .isSecureTextEntry(
                                !self.isPasswordShow
                            )
                            
                            .rightView({
                                Button(action: {
                                    withAnimation {
                                        self.isPasswordShow.toggle()
                                    }
                                    
                                }) {
                                    Image(systemName: self.isPasswordShow ? "eye" : "eye.slash")
                                        .foregroundStyle(ColorClass.getThemGradientColor(theme: themeModel.themeApp))
                                }
                            })
                        
                            .floatingStyle(ThemeTextFieldStyle(themeColor: themeModel.themeApp))
//                            .selectedTitleColor(password.count >= 7 ? Color.redColor1 : .black)
                            
                            .frame(height: 70)
                            .padding(.horizontal)
                        
                        NavigationLink(destination: ListView()) {
                            Text("Sign in")
                                .foregroundStyle(.white)
                                .bold()
                                .font(.title3)
                                .frame(maxWidth: .infinity, maxHeight: 70, alignment: .center)
                                .padding(10)
                                .background(Capsule().fill(ColorClass.getThemGradientColor(theme: themeModel.themeApp)))
                                .padding(.horizontal)
                                .padding(.top, 40)
                        }
                        
                    }
                    
                }
                    
//                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedCorner(radius: 30, corners: [.topLeft, .topRight]).fill(.white)
                )
                .padding(.top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    LoginView()
}
