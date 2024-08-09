//
//  Utils.swift
//  RecoordingVideo
//
//  Created by Bilal Mughal on 09/08/2024.
//

import Foundation
import UIKit

// MARK: - CONSTANTS

struct Constant {
    static var fontName = "Matt Antique Bold"
    
    static func isRunningOnSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    static var isRealDevice: Bool{
        let deviceType = UIDevice.current.model
        if isRunningOnSimulator() {
            print("Running on Simulator")
            return false
        } else {
            print("Running on Device: \(deviceType)")
            return true
        }
    }
    
    
    
}

// MARK: - THREAD

struct Thread {
    static func mainThread(_ completion: @escaping () -> ()) {
        DispatchQueue.main.async {
            completion()
        }
    }
    
    static func asynAfter(_ time: CGFloat, _ completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now()+time, execute: {
            completion()
        })
    }
}


// MARK: - EXTENSIONS

extension UIColor {
    static var themeRed: UIColor {
        return UIColor(red: 205/255, green: 28/255, blue: 9/255, alpha: 1)
    }
}

extension UILabel {
    func setFont(size: CGFloat? = nil) {
        self.font = UIFont(name: "Matt Antique Bold", size: self.font.pointSize)
    }
}

extension UIView {
    func removeAllConstraints() {
        // Remove all constraints affecting the view
        NSLayoutConstraint.deactivate(self.constraints)
        
        // Remove any constraints from the superview that reference the view
        if let superview = self.superview {
            superview.constraints.forEach { constraint in
                if constraint.firstItem as? UIView == self || constraint.secondItem as? UIView == self {
                    superview.removeConstraint(constraint)
                }
            }
        }
    }
}
