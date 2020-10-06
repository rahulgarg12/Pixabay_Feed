//
//  FeedTableCell.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit
import Combine

final class FeedTableCell: IGTableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.bounds.width / 2
            userImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var usernameLabel: NameLabel!
    @IBOutlet weak var locationLabel: LocationLabel!
    @IBOutlet weak var bookmarkButton: UIButton! {
        didSet {
            bookmarkButton.setImage(UIImage(named: "bookmark"), for: .normal)
            bookmarkButton.setImage(UIImage(named: "bookmarkRed"), for: .selected)
        }
    }
    
    //MARK: properties
    enum Action {
        case didTapBookmarkButton(HitModel?)
    }
    var subject = PassthroughSubject<Action, Never>()
    
    var object: HitModel? {
        didSet {
            usernameLabel.text = object?.user
            ImageHandler().setLazily(urlString: object?.userImageURL, imageView: userImageView)
            ImageHandler().setLazily(urlString: object?.largeImageURL, imageView: mainImageView)
            locationLabel.text = object?.tags
            bookmarkButton.isSelected = object?.isBookmark ?? false
        }
    }
    
    //MARK: Overriden methods
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setBookmarkStatus(_ enable: Bool) {
        bookmarkButton.isSelected = enable
    }
    
    @IBAction private func didTapBookmarkButton(_ sender: UIButton) {
        guard let object = object else { return }
        
        subject.send(.didTapBookmarkButton(object))
        
        let idBookmarkModel = IdBookmarkModel(id: object.id, bookmark: !object.isBookmark)
        NotificationCenter.default.post(name: .didTapBookmark, object: idBookmarkModel)
    }
}
