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
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var number: String = ""
    @State private var password: String = ""
    
    @FocusState private var nameIsFocused: Bool
    
    let redColor: Color = Color(red: 181/255, green: 24/255, blue: 55/255)
    
    var body: some View {
       
        ZStack {
            LinearGradient(colors: [Color(red: 181/255, green: 24/255, blue: 55/255) , Color(red: 44/255, green: 25/255, blue: 54/255)], startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.top)
            
            VStack(alignment: .leading) {
                HStack{
                    Text("Create Your Account")
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
                        
                        FloatingLabelTextField($name, placeholder: "Name")
                            .floatingStyle(ThemeTextFieldStyle())
                            .frame(height: 70)
                            .padding(.horizontal)
                            .padding(.top, 50)
                        
                        
                        FloatingLabelTextField($email, placeholder: "Email")
                            .addValidation(.init(condition: email.isValid(.email),
                                                 errorMessage: "Invalid Email"))
                            .isShowError(true)
                            .errorColor(redColor)
                            .floatingStyle(ThemeTextFieldStyle2())
                            .keyboardType(.emailAddress)
                            .frame(height: 70)
                            .padding(.horizontal)
                        
                        FloatingLabelTextField($number, placeholder: "Number")
                            .floatingStyle(ThemeTextFieldStyle())
                            .frame(height: 70)
                            .padding(.horizontal)
                            .keyboardType(.numberPad)
                            .focused($nameIsFocused)
                        
                        FloatingLabelTextField($password, placeholder: "Password")
                            .isSecureTextEntry(true)
                            .floatingStyle(ThemeTextFieldStyle2())
                            .frame(height: 70)
                            .padding(.horizontal)
                        
                        Button{print("asdansd")} label: {
                            Text("Sign up")
                                .foregroundStyle(.white)
                                .bold()
                                .font(.title3)
                                .frame(maxWidth: .infinity, maxHeight: 70, alignment: .center)
                                .padding(10)
                                .background(Capsule().fill(LinearGradient(colors: [Color(red: 181/255, green: 24/255, blue: 55/255) , Color(red: 44/255, green: 25/255, blue: 54/255)], startPoint: .leading, endPoint: .trailing)))
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
    }
}


struct LoginView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var number: String = ""
    @State private var password: String = ""
    
    @FocusState private var nameIsFocused: Bool
    
    let redColor: Color = Color(red: 181/255, green: 24/255, blue: 55/255)
    
    var body: some View {
       
        ZStack {
            LinearGradient(colors: [Color(red: 181/255, green: 24/255, blue: 55/255) , Color(red: 44/255, green: 25/255, blue: 54/255)], startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.top)
            
            VStack(alignment: .leading) {
                HStack{
                    Text("Login")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .bold()
                        .frame(maxWidth: 100, alignment: .leading)
                    Spacer()
                    
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.gray)
                       
               
                    
                }
                .padding(.horizontal, 40)
                
//                ZStack {
                VStack{
                    ScrollView {
                        
                        
                        
                        FloatingLabelTextField($email, placeholder: "Email")
                            .addValidation(.init(condition: email.isValid(.email),
                                                 errorMessage: "Invalid Email"))
                            .isShowError(true)
                            .errorColor(redColor)
                            .floatingStyle(ThemeTextFieldStyle2())
                            .keyboardType(.emailAddress)
                            .frame(height: 70)
                            .padding(.horizontal)
                            .padding(.top, 100)
                            
                        
                        FloatingLabelTextField($password, placeholder: "Password")
                            .isSecureTextEntry(true)
                            .floatingStyle(ThemeTextFieldStyle2())
                            .frame(height: 70)
                            .padding(.horizontal)
                        
                        Button{print("asdansd")} label: {
                            Text("Sign in")
                                .foregroundStyle(.white)
                                .bold()
                                .font(.title3)
                                .frame(maxWidth: .infinity, maxHeight: 70, alignment: .center)
                                .padding(10)
                                .background(Capsule().fill(LinearGradient(colors: [Color(red: 181/255, green: 24/255, blue: 55/255) , Color(red: 44/255, green: 25/255, blue: 54/255)], startPoint: .leading, endPoint: .trailing)))
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
    }
}


struct ListView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var number: String = ""
    @State private var password: String = ""
    
    @FocusState private var nameIsFocused: Bool
    
    let redColor: Color = Color(red: 181/255, green: 24/255, blue: 55/255)
    
    var body: some View {
       
        ZStack {
            LinearGradient(colors: [Color(red: 181/255, green: 24/255, blue: 55/255) , Color(red: 44/255, green: 25/255, blue: 54/255)], startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.top)
            
            VStack(spacing: 10) {
                HStack{
                    Text("Messages")
                        .font(.title)
                        .foregroundStyle(.white)
                        .bold()
                        .frame(maxWidth: 170, alignment: .leading)
                    Spacer()
                    
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.gray)
                       
               
                    
                }
                .padding(.horizontal, 40)
                
//                ZStack {
                VStack{
                    ScrollView {
                        
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
                        
                        ExtractedView()
//                        .padding(.top)
                        
                        
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
    }
}

#Preview {
    HomeView()
}

#Preview {
    LoginView()
}

#Preview {
    SignupView()
}

#Preview {
    ListView()
}

import FloatingLabelTextFieldSwiftUI


struct ThemeTextFieldStyle: FloatingLabelTextFieldStyle {
    
    let redColor: Color = Color(red: 181/255, green: 24/255, blue: 55/255)
    
    func body(content: FloatingLabelTextField) -> FloatingLabelTextField {
        content
//            .spaceBetweenTitleText(15) // Sets the space between title and text.
            .textAlignment(.leading) // Sets the alignment for text.
//            .lineHeight(1) // Sets the line height.
//            .selectedLineHeight(1.5) // Sets the selected line height.
            .lineColor(.gray) // Sets the line color.
            .selectedLineColor(redColor) // Sets the selected line color.
            .titleColor(.gray) // Sets the title color.
            .selectedTitleColor(redColor) // Sets the selected title color.
//            .titleFont(.system(size: 12)) // Sets the title font.
            .textColor(.black) // Sets the text color.
            .selectedTextColor(redColor) // Sets the selected text color.
//            .textFont(.system(size: 15)) // Sets the text font.
            .placeholderColor(.gray) // Sets the placeholder color.
//            .placeholderFont(.system(size: 15)) // Sets the placeholder font.
            .errorColor(redColor) // Sets the error color.
//            .addDisableEditingAction([.paste]) // Disable text field editing action. Like cut, copy, past, all etc.
//            .enablePlaceholderOnFocus(true) // Enable the placeholder label when the textfield is focused.
            .allowsHitTesting(true) // Whether this view participates in hit test operations.
            .disabled(false) // Whether users can interact with this.
    }
}


struct ThemeTextFieldStyle2: FloatingLabelTextFieldStyle {
    
    let redColor: Color = Color(red: 181/255, green: 24/255, blue: 55/255)
    
    func body(content: FloatingLabelTextField) -> FloatingLabelTextField {
        content
//            .spaceBetweenTitleText(15) // Sets the space between title and text.
            .textAlignment(.leading) // Sets the alignment for text.
//            .lineHeight(1) // Sets the line height.
//            .selectedLineHeight(1.5) // Sets the selected line height.
            .lineColor(.gray) // Sets the line color.
            .selectedLineColor(redColor) // Sets the selected line color.
            .titleColor(.gray) // Sets the title color.
            .selectedTitleColor(redColor) // Sets the selected title color.
//            .titleFont(.system(size: 12)) // Sets the title font.
            .textColor(.black) // Sets the text color.
            .selectedTextColor(redColor) // Sets the selected text color.
//            .textFont(.system(size: 15)) // Sets the text font.
            .placeholderColor(.gray) // Sets the placeholder color.
//            .placeholderFont(.system(size: 15)) // Sets the placeholder font.
            .errorColor(redColor) // Sets the error color.
            .isSecureTextEntry(true)
//            .addDisableEditingAction([.paste]) // Disable text field editing action. Like cut, copy, past, all etc.
//            .enablePlaceholderOnFocus(true) // Enable the placeholder label when the textfield is focused.
            .allowsHitTesting(true) // Whether this view participates in hit test operations.
            .disabled(false) // Whether users can interact with this.
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = 25.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct ExtractedView: View {
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 55, height: 55)
            
            VStack(alignment: .leading, spacing: 0){
                Text("Mollie Asutin")
                    .font(.title3)
                    .bold()
                
                Text("Mollie Asutin")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("2:34 pm")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                
                Text("")
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
