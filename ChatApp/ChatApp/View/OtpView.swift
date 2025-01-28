//
//  OtpView.swift
//  ChatApp
//
//  Created by Bilal Mughal on 28/01/2025.
//

import Foundation
import SwiftUI
import OTPView

struct otpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var number: String = ""
    @State private var password: String = ""
    
    @FocusState private var nameIsFocused: Bool
    
    @State private var isPasswordShow: Bool = false
    
    let gradientColor = LinearGradient(colors: [Color(red: 181/255, green: 24/255, blue: 55/255) , Color(red: 44/255, green: 25/255, blue: 54/255)], startPoint: .leading, endPoint: .trailing)
    
    let redColor: Color = Color(red: 181/255, green: 24/255, blue: 55/255)
    
    var body: some View {
       
        ZStack {
            LinearGradient(colors: [Color(red: 181/255, green: 24/255, blue: 55/255) , Color(red: 44/255, green: 25/255, blue: 54/255)], startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.top)
            
            VStack(alignment: .leading) {
                HStack{
                    Text("Verification")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .bold()
                        .frame(maxWidth: 200, alignment: .leading)
                    Spacer()
                    
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.gray)
                       
               
                    
                }
                .padding(.horizontal, 40)
                
//                ZStack {
                VStack{
                    ScrollView {
                        
                        Text("Enter OTP")
                            .bold()
                            .font(.title)
                            .foregroundStyle(.black)
                            .padding(.top, 100)
                        
                        Text("We have just sent you 4 dgits code via your phone and email")
                            .font(.caption)
                            .foregroundStyle(Color.black.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 50)
                        
                        OtpView(activeIndicatorColor: redColor, inactiveIndicatorColor: Color.gray,  length: 4, doSomething: { value in
                                        // Do something with the value input
                        })
                        .padding(.horizontal)
                  
                        
                        Button{print("asdansd")} label: {
                            Text("Next")
                                .foregroundStyle(.white)
                                .bold()
                                .font(.title3)
                                .frame(maxWidth: .infinity, maxHeight: 70, alignment: .center)
                                .padding(10)
                                .background(Capsule().fill(LinearGradient(colors: [Color(red: 181/255, green: 24/255, blue: 55/255) , Color(red: 44/255, green: 25/255, blue: 54/255)], startPoint: .leading, endPoint: .trailing)))
                                .padding(.horizontal)
                                .padding(.top, 20)
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
    }
}


#Preview {
    otpView()
}
