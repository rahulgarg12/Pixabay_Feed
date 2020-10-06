//
//  UIFont+Extension.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit

enum FontType: String {
    case black = "Black"
    case bold = "Bold"
    case heavy = "Heavy"
    case light = "Light"
    case regular = "Regular"
    case medium = "Medium"
    case semibold = "Semibold"
}

enum FontName: String {
    case SFPro = "SFProDisplay"
}

enum FontSize: CGFloat {
    case headline = 16
    case name = 13
    case location = 11
}

extension UIFont {
    static func font(_ name: FontName, type: FontType, size: CGFloat) -> UIFont {
        let font = UIFont(name: name.rawValue + "-" + type.rawValue, size: size)
        return font!
    }
    
    static func font(type: FontType, size: CGFloat) -> UIFont {
        return font(.SFPro, type: type, size: size)
    }
}
