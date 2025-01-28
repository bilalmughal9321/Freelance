//
//  ListView.swift
//  ChatApp
//
//  Created by Bilal Mughal on 28/01/2025.
//

import Foundation
import SwiftUI

struct ListView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var number: String = ""
    @State private var password: String = ""
    
    @FocusState private var nameIsFocused: Bool
    
    @State var searchField: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var themeModel: theme
    
//    let redColor: Color = Color(red: 181/255, green: 24/255, blue: 55/255)
//    
//    let gradientColor = LinearGradient(colors: [Color(red: 181/255, green: 24/255, blue: 55/255) , Color(red: 44/255, green: 25/255, blue: 54/255)], startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
       
        ZStack {
            ColorClass.getThemGradientColor(theme: themeModel.themeApp)
                .edgesIgnoringSafeArea([.top, .leading, .trailing])
            
            VStack(spacing: 10) {
                HStack(spacing: 25){
                    
                    Button {presentationMode.wrappedValue.dismiss()} label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 12, height: 20)
                            .foregroundStyle(.white)
                            .bold()
                    }
                    
                    
                    Text("Messages")
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
                        
                        TextField("Search", text: $searchField)
                            .padding()
                            .background(Capsule().fill(Color.gray.opacity(0.1)))
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        
                        ForEach([1,2,3,4,5,6,7,8,9,10], id: \.self) { message in
                            ChatCell()
                        }
                    }
                    
                }
                    
//                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top)
                .background(
                    RoundedCorner(radius: 30, corners: [.topLeft, .topRight]).fill(.white)
                )
//                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct ChatCell: View {
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 45, height: 45)
            
            VStack(alignment: .leading, spacing: 0){
                Text("Mollie Asutin")
                    .font(.custom("Fontspring-coresansar85it", size: 16))
                    .bold()
                
                Text("Mollie Asutin")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("2:34 pm")
                    .font(.custom("Fontspring-coresansar85it", size: 11))
                    .foregroundStyle(.gray)
                
                Text("")
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}


#Preview {
    ListView()
}
