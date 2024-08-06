//
//  DashboardView.swift
//  efc_italia
//
//  Created by Bilal Mughal on 24/07/2024.
//

import Foundation
import SwiftUI

struct DashboardView: View {
    var body: some View {
        
       
        ScrollView{
            VStack(spacing: 15, content: {
                
                Text("Account")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack(spacing: 15) {
                    
                    Text("First Name")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SepratorLine()      
                    Text("Last Name")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SepratorLine()
                    Text("Phone")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SepratorLine()
                    Text("Email")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                
                Text("Change Password")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal, .top], 10)
                
                VStack(spacing: 15) {
                    
                    Text("Old Password")
                        .font(.subheadline)
                    //                    .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SepratorLine()
                    Text("New Passowrd")
                        .font(.subheadline)
                    //                    .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SepratorLine()
                    Text("Repeat Password")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                
                
                
                HStack(spacing: 15) {
                    Button(action: {
                        
                    }, label: {
                        ButtonSubView2(name: "Logout")
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        AuthenticateBtn(name: "Save")
                    })
                }.padding(.top)
                
                Spacer()
                
                
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .top])
            
            
            
            Spacer()
        }
        
    }
}

#Preview {
//    rgb(247, 250, 252)
    DashboardView()
        .background(Color(red: 247/255, green: 250/255, blue: 252/255))
}


struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}
