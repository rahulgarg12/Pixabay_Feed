//
//  UINavigationController+Extension.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit

extension UINavigationController {
    func hideHairline() {
        self.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}
