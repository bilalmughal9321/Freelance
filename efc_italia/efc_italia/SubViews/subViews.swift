//
//  subViews.swift
//  efc_italia
//
//  Created by Bilal Mughal on 24/07/2024.
//

import Foundation
import SwiftUI

struct BackgroundGradientView: View {
    var body: some View {
        LinearGradient(colors: [Color(red: 108/255, green: 67/255, blue: 143/255), Color(red: 53/255, green: 34/255, blue: 69/255)], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 0))
            .cornerRadius(20, corners: [.topLeft, .topRight])
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ExtractedTextField: View {
    @State var name: String
    @Binding var field: String
    var body: some View {
        TextField(name, text: $field)
            .foregroundStyle(.black)
            .padding()
            .frame(height: 50)
            .background(
                Capsule().fill(Color(red: 241/255, green: 244/255, blue: 248/255))
            )
    }
}

struct ExtractedSecureField: View {
    @State var name: String
    @Binding var field: String
    var body: some View {
        SecureField(name, text: $field)
            .foregroundStyle(.black)
            .padding()
            .frame(height: 50)
            .background(
                Capsule().fill(Color(red: 241/255, green: 244/255, blue: 248/255))
            )
    }
}

struct AuthenticateBtn: View {
    @State var name: String
    var body: some View {
        Text(name)
            .padding()
            .foregroundStyle(Color.white)
            .bold()
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.lightPurple, .DarkPurple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .cornerRadius(30)
            )
    }
}

struct ButtonSubView2: View {
    @State var name: String
    var body: some View {
        Text(name)
            .padding()
            .foregroundStyle(Color.lightPurple)
            .bold()
            .frame(maxWidth: .infinity)
            .frame(height: 50)
//            .background(Color.white)
            .background(
                Capsule().stroke(Color.lightPurple, lineWidth: 1)
            )
    }
}


//MARK: -

struct SepratorLine: View {
    @State var color: Color = Color.gray
    var body: some View {
        Line().stroke(color, lineWidth: 0.1).frame(height: 1)
    }
}


extension Color {
    static var lightPurple: Color {
        return Color(red: 108/255, green: 67/255, blue: 143/255)
    }
    
    static var DarkPurple: Color {
        return Color(red: 53/255, green: 34/255, blue: 69/255)
    }
}
