//
//  Utils.swift
//  ChatApp
//
//  Created by Bilal Mughal on 28/01/2025.
//

import Foundation
import FloatingLabelTextFieldSwiftUI
import SwiftUI


struct ThemeTextFieldStyle: FloatingLabelTextFieldStyle {
    
    var themeColor: themeColor
    
    let redColor: Color = Color(red: 181/255, green: 24/255, blue: 55/255)
    
    let gradientColor = LinearGradient(colors: [Color(red: 181/255, green: 24/255, blue: 55/255) , Color(red: 44/255, green: 25/255, blue: 54/255)], startPoint: .leading, endPoint: .trailing)
    
    func body(content: FloatingLabelTextField) -> FloatingLabelTextField {
        content
//            .spaceBetweenTitleText(15) // Sets the space between title and text.
            .textAlignment(.leading) // Sets the alignment for text.
//            .lineHeight(1) // Sets the line height.
//            .selectedLineHeight(1.5) // Sets the selected line height.
            .lineColor(.gray) // Sets the line color.
            .selectedLineColor(themeColor == .red ? Color.redColor1 : Color.blueColor1) // Sets the selected line color.
            .titleColor(.gray) // Sets the title color.
            .selectedTitleColor(.black) // Sets the selected title color.
//            .titleFont(.system(size: 12)) // Sets the title font.
            .textColor(.black) // Sets the text color.
            .selectedTextColor(.black) // Sets the selected text color.
//            .textFont(.system(size: 15)) // Sets the text font.
            .placeholderColor(.gray) // Sets the placeholder color.
//            .placeholderFont(.system(size: 15)) // Sets the placeholder font.
            .errorColor(Color.redColor1) // Sets the error color.
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


struct ColorClass {
    
    static func getThemGradientColor(theme: themeColor) -> LinearGradient{
        
        return LinearGradient(
            colors: [
                theme == .red ? Color.redColor1 : Color.blueColor1,
                theme == .red ? Color.redColor2 : Color.blueColor2
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        
    }
    
}

extension Color {
    
    static var redColor1: Color {
        return Color(red: 181/255, green: 24/255, blue: 55/255)
    }
    
    static var redColor2: Color {
        return Color(red: 44/255, green: 25/255, blue: 54/255)
    }
    
    static var blueColor1: Color {
        return Color(red: 0/255, green: 108/255, blue: 254/255)
    }
    
    static var blueColor2: Color {
//        (4, 65, 150)
        return Color(red: 4/255, green: 65/255, blue: 150/255)
    }
    
}


struct DateFunc {
    
    static var currentTime: String {
        // Current time interval since 1970
        let timeInterval = Date().timeIntervalSince1970

        // Convert timeInterval to Date object
        let date = Date(timeIntervalSince1970: timeInterval)

        // Format only the time
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .medium // Time style (e.g., 12:34:56 PM)
        timeFormatter.dateStyle = .none  // No date
        timeFormatter.locale = Locale(identifier: "en_US") // Locale (optional)

        // Convert date to formatted time string
        return timeFormatter.string(from: date)
    }
    
}

struct Utils {
    
    static var overlay: UIView?
    static func showActivityIndicator() {
        
        let window = UIApplication.shared.keyWindow ?? UIWindow(frame: CGRect.zero)
        
        DispatchQueue.main.async {
            overlay?.removeFromSuperview()
            overlay = UIView(frame: window.bounds)
            overlay!.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            overlay!.isUserInteractionEnabled = true // Blocks user interaction
            
            // Add activity indicator
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.color = .white
            activityIndicator.center = overlay!.center
            activityIndicator.startAnimating()
            overlay!.addSubview(activityIndicator)
            
            window.addSubview(overlay!)
        }
    }
    
    static func hideActivityIndicator() {
        DispatchQueue.main.async {
            overlay?.removeFromSuperview()
        }
    }
    
}
