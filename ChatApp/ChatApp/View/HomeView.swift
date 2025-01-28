//
//  HomeView.swift
//  ChatApp
//
//  Created by Bilal Mughal on 28/01/2025.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var themeModel: theme
        
    var body: some View {
        NavigationView {
            ZStack {
                ColorClass.getThemGradientColor(theme: themeModel.themeApp)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30){
                    
                    Text("Welcome Back")
                        .subtitle()
                        .foregroundStyle(.white)
                        .bold()

                    NavigationLink(destination: LoginView().environmentObject(themeModel)) {
                        Text("Sign in")
                            .bold()
                            .foregroundStyle(.white)
//                            .font(.title2)
                            .headline()
                            .background(.clear)
                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                            .padding(5)
                            .background(Capsule().stroke(.white, lineWidth: 1.5))
                            .padding(.horizontal, 40)
                    }.padding(.top)
                    
                    
                    NavigationLink(destination: SignupView().environmentObject(themeModel)) {
                        Text("Sign up")
                            .bold()
                            .foregroundStyle(.black)
                            .headline()
                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                            .padding(5)
                            .background(Capsule().fill(.white))
                            .padding(.horizontal, 40)
                            
                    }
                    
            
                    
//                    Button {
//                        if themeModel.themeApp == .blue {
//                            withAnimation {
//                                themeModel.themeApp = .red
//                            }
//                            
//                        }
//                        else {
//                            withAnimation {
//                                themeModel.themeApp = .blue
//                            }
//                        }
//                    } label: {
//                        Text("jabsjdhbasjhbajhsfbajsfb")
//                        
//                    }
                    
                    
                 
                        
                    
                    
                }
                
                
            }
        }
       
    }
}


#Preview {
    HomeView().environmentObject(theme())
}


extension View {
    
    func title() -> some View {
        self.font(.custom("Courgette-Regular", size: 50))
    }
    
    func subtitle() -> some View {
        self.font(.custom("Courgette-Regular", size: 30))
    }
    
    func headline() -> some View {
        self.font(.custom("Courgette-Regular", size: 20))
    }
    
    func body() -> some View {
        self.font(.custom("Courgette-Regular", size: 15))
    }
    
}
