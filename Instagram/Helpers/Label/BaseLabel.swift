//
//  BaseLabel.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit

class BaseLabel: UILabel {

    func setup() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override var text: String? {
        didSet {
            setNeedsDisplay()
        }
    }
}
