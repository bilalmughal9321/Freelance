//
//  theme.swift
//  ChatApp
//
//  Created by Bilal Mughal on 28/01/2025.
//

import SwiftUI

enum themeColor {
    case red
    case blue
}

class theme: ObservableObject {
    
    @Published var themeApp: themeColor = .red
    
}
