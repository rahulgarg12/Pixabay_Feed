//
//  LocationLabel.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit

final class LocationLabel: BaseLabel {

    override func setup() {
        super.setup()
        self.font = UIFont.font(type: .regular, size: FontSize.location.rawValue)
        setAttributedText(text: self.text ?? "")
        self.textColor = UIColor.appBlack
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    func setAttributedText(text: String) {
        self.set(text: text, withCharacterSpacing: 0.07, lineHeight: 13.13)
    }

}

