//
//  UILabel+Extension.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit

extension UILabel {
    func set(text: String, withCharacterSpacing: CGFloat, lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight - self.font.lineHeight
        paragraphStyle.alignment = self.textAlignment
        if !(self.superview?.isKind(of: UIButton.self) ?? false) {
            paragraphStyle.lineBreakMode = .byTruncatingTail
        }
        let attributes = [.kern: withCharacterSpacing, .paragraphStyle: paragraphStyle] as [NSAttributedString.Key : Any]
        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
        self.attributedText = attributedString
    }
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.attributedText?.string ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font ?? UIFont.systemFont(ofSize: 14.0)], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
