//
//  HeadingLabel.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit

final class HeadingLabel: BaseLabel {

    override func setup() {
        super.setup()
        self.font = UIFont.font(type: .semibold, size: FontSize.headline.rawValue)
        setAttributedText(text: self.text ?? "")
        self.textColor = UIColor.appBlack
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func setAttributedText(text: String) {
        self.set(text: text, withCharacterSpacing: 0, lineHeight: 21)
    }

}
