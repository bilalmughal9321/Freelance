//
//  RegisterView.swift
//  ChatApp
//
//  Created by Bilal Mughal on 28/01/2025.
//

import Foundation
import FloatingLabelTextFieldSwiftUI
import SwiftUI
import Alamofire

struct SignupView: View {
    
    @EnvironmentObject var themeModel: theme
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var number: String = ""
    @State private var password: String = ""
    
    @FocusState private var nameIsFocused: Bool
    
    @State private var isPasswordShow: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
       
        ZStack {
            ColorClass.getThemGradientColor(theme: themeModel.themeApp)
                .edgesIgnoringSafeArea(.top)
            
            VStack(alignment: .leading) {
                HStack(spacing: 25){
                    
                    Button {presentationMode.wrappedValue.dismiss()} label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 12, height: 20)
                            .foregroundStyle(.white)
                            .bold()
                    }
                    
                    Text("Create Your Account")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .bold()
                        .frame(maxWidth: 190, alignment: .leading)
                    Spacer()
                    
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.gray)
                       
               
                    
                }
                .padding(.horizontal, 20)
                
//                ZStack {
                VStack{
                    ScrollView {
                        
                        FloatingLabelTextField($name, placeholder: "Name")
                            .floatingStyle(ThemeTextFieldStyle(themeColor: themeModel.themeApp))
                            .frame(height: 70)
                            .padding(.horizontal)
                            .padding(.top, 50)
                        
                        
                        FloatingLabelTextField($email, placeholder: "Email")
//                            .addValidation(.init(condition: email.isValid(.email),
//                                                 errorMessage: "Invalid Email"))
                            .isShowError(true)
                            .errorColor(themeModel.themeApp == .red ? Color.redColor1 : Color.blueColor1)
                            .floatingStyle(ThemeTextFieldStyle(themeColor: themeModel.themeApp))
                            .keyboardType(.emailAddress)
                            .frame(height: 70)
                            .padding(.horizontal)
                        
                        FloatingLabelTextField($number, placeholder: "Number")
                            .floatingStyle(ThemeTextFieldStyle(themeColor: themeModel.themeApp))
                            .frame(height: 70)
                            .padding(.horizontal)
                            .keyboardType(.numberPad)
                            .focused($nameIsFocused)
                        
                        FloatingLabelTextField($password, placeholder: "Password")
                            .isSecureTextEntry(true)
//                            .addValidation(
//                                .init(
//                                    condition: password.count >= 7,
//                                    errorMessage: "Minimum 8 character long"
//                                )
//                            )
                            .isShowError(true)
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
                            .frame(height: 70)
                            .padding(.horizontal)
                        
//                        NavigationLink(destination: Toaster()) {
//
//                        }
                        
                        Button {
                            
                            guard name != "" else {
                                return print("name is missing")
                            }
                            
                            guard email != "" else {
                                return print("email is missing")
                            }
                            
                            guard number != "" else {
                                return print("number is missing")
                            }
                            
                            guard password != "" else {
                                return print("password is missing")
                            }
                       
                            
                            let request = registerRequest(name: name, email: email, password: password)
                            
                            Utils.showActivityIndicator()
                            
                            AlamofireWrapper.shared
                                .request(
                                    method: .post,
                                    endpoint: "/register",
                                    parameters: request) {  (result: Result<OTPResponse, Error>) in
                                        
                                        DispatchQueue.main.async {
                                            Utils.hideActivityIndicator()
                                        }
                                       
                                    }
                            
                        } label: {
                            Text("Sign up")
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
    Toaster()
}

struct Toaster: View {
    var msg: String = "Invalid Credentials"
    @State var isVisible: Bool = true

    var body: some View {
        if isVisible {
            Text(msg)
                .foregroundStyle(.white)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.7))
                )
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            isVisible = false
                        }
                       
                    }
                }
        }
    }
}

struct registerRequest: Encodable {
    let name: String
    let email: String
    let password: String
}

struct OTPResponse: Codable {
    let data: otpData?
    let message: String?
}

struct otpData: Codable {
    let otpCode: String
    let emailSent: Bool
    
    enum CodingKeys: String, CodingKey {
        case otpCode = "otp_code"
        case emailSent = "email_sent"
    }
}

