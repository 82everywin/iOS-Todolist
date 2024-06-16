//
//  Extension+.swift
//  TodoApp
//
//  Created by 한현승 on 5/26/24.
//

import Foundation
import UIKit

extension CategoryViewCell {
    static var identifier: String {
        return String (describing: self)
    }
}

extension TodoViewCell {
    static var identifier: String {
        return String (describing: self)
    }
}

extension AddCategoryCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
            var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
            
            if hexFormatted.hasPrefix("#") {
                hexFormatted = String(hexFormatted.dropFirst())
            }
            
            assert(hexFormatted.count == 6, "Invalid hex code used.")
            
            var rgbValue: UInt64 = 0
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
            
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
    }
    
    static let fontColor = UIColor(hexCode: "735B37")
    static let labelFontColor = UIColor(hexCode: "553910")
    static let grayBackgroud = UIColor(hexCode: "F5F5F5")
    static let MainBackground = UIColor(hexCode:"4260FF")
    
    static let lineColor = UIColor(hexCode: "EAEAEA")
    
    static let boldPink = UIColor(hexCode: "F9B0CA")
    static let boldYellow = UIColor(hexCode: "FFE560")
    static let boldGreen = UIColor(hexCode: "47D2CA")
    static let boldPurple = UIColor(hexCode: "B6B0F9")
    static let thinPink = UIColor(hexCode: "FFF5F9")
    static let thinYellow = UIColor(hexCode: "FFFDEE")
    static let thinGreen = UIColor(hexCode: "F0FFFE")
    static let thinPurple = UIColor(hexCode: "F2F1FF")
}
