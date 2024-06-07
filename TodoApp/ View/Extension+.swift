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
    var hexString: String {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
            return String(format:"#%06x", rgb)
    }
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
            var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
            
            if hexFormatted.hasPrefix("#") {
                hexFormatted = String(hexFormatted.dropFirst())
            }
            
            assert(hexFormatted.count == 6, "Invalid hex code used.")
            
            var rgbValue: UInt64 = 0
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
            
            let mask = 0x000000FF
            let r = Int(rgbValue >> 16) & mask
            let g = Int(rgbValue >> 8) & mask
            let b = Int(rgbValue) & mask
            
            let red = CGFloat(r) / 255.0
            let green = CGFloat(g) / 255.0
            let blue = CGFloat(b) / 255.0
            
            self.init(red: red, green: green, blue: blue, alpha: alpha)
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
    static let thinPurple = UIColor(hexCode: "B6B0F9")
}


