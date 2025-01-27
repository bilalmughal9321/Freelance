//
//  HomeView.swift
//  ChatApp
//
//  Created by Bilal Mughal on 27/01/2025.
//

import SwiftUI

struct HomeView: View {
    
    let redColor: Color = Color(red: 181/255, green: 24/255, blue: 55/255)
    
    let color: Color = Color(red: 44/255, green: 25/255, blue: 54/255)
    
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [redColor , color], startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                
                Text("Welcome Back")
                    .font(.title)
                    .foregroundStyle(.white)
                    .bold()
                
                Button{ } label: {
                    Text("SIGN IN")
                        .bold()
                        .foregroundStyle(.white)
                        .font(.title2)
                        .background(.clear)
                        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                        .padding(5)
                        .background(Capsule().stroke(.white, lineWidth: 1.5))
                        .padding(.horizontal, 40)
                }
                .padding(.top)
                
                Button{ } label: {
                    Text("SIGN UP")
                        .bold()
                        .foregroundStyle(.black)
                        .font(.title2)
                        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                        .padding(5)
                        .background(Capsule().fill(.white))
                        .padding(.horizontal, 40)
                        
                }
                
                
             
                    
                
                
            }
            
            
        }
    }
}

struct SignupView: View {
    @State private var firstName: String = ""
    @State private var firstName2: String = ""
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 181/255, green: 24/255, blue: 55/255) , Color(red: 44/255, green: 25/255, blue: 54/255)], startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                HStack{
                    Text("Create Your Account")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .bold()
                        .frame(maxWidth: 200, alignment: .leading)
                    Spacer()
                }.padding(.leading, 40)
                
                ZStack {
                    VStack{
                        FloatingLabelTextField($firstName, placeholder: "First Name", editingChanged: { (isChanged) in
                            
                        }) {
                            
                        }
                        .floatingStyle(ThemeTextFieldStyle())
                        .frame(height: 70)
                        
                        
                        FloatingLabelTextField($firstName2, placeholder: "Second Name", editingChanged: { (isChanged) in
                                    
                                }) {
                                    
                                }.frame(height: 70)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30).fill(.white)
                )
                .padding(.top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    SignupView()

}

import FloatingLabelTextFieldSwiftUI


struct ThemeTextFieldStyle: FloatingLabelTextFieldStyle {
    func body(content: FloatingLabelTextField) -> FloatingLabelTextField {
        content
//            .spaceBetweenTitleText(15) // Sets the space between title and text.
            .textAlignment(.leading) // Sets the alignment for text.
            .lineHeight(1) // Sets the line height.
            .selectedLineHeight(1.5) // Sets the selected line height.
            .lineColor(.gray) // Sets the line color.
            .selectedLineColor(.red) // Sets the selected line color.
            .titleColor(.gray) // Sets the title color.
            .selectedTitleColor(.red) // Sets the selected title color.
            .titleFont(.system(size: 12)) // Sets the title font.
            .textColor(.black) // Sets the text color.
            .selectedTextColor(.red) // Sets the selected text color.
            .textFont(.system(size: 15)) // Sets the text font.
            .placeholderColor(.gray) // Sets the placeholder color.
            .placeholderFont(.system(size: 15)) // Sets the placeholder font.
            .errorColor(.red) // Sets the error color.
            .addDisableEditingAction([.paste]) // Disable text field editing action. Like cut, copy, past, all etc.
            .enablePlaceholderOnFocus(true) // Enable the placeholder label when the textfield is focused.
            .allowsHitTesting(true) // Whether this view participates in hit test operations.
            .disabled(false) // Whether users can interact with this.
    }
}
