//
//  IGTableViewCell.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit
import Combine

class IGTableViewCell: UITableViewCell {
    var cancellables = Set<AnyCancellable>()
    
    var indexPath: IndexPath?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables = Set<AnyCancellable>()
    }
}
