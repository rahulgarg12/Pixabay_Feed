//
//  ImageHandler.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit
import Kingfisher

struct ImageHandler {
    
    func setLazily(urlString: String?, imageView: UIImageView) {
        if let urlString = urlString, let url = URL(string: urlString) {
            imageView.kf.setImage(with: url, placeholder: UIImage().getPlaceHolderImage())
        } else {
            imageView.image = UIImage().getPlaceHolderImage()
        }
    }
    
    func prefetch(urls: [String]) {
        let urls = urls.compactMap { URL(string: $0) }
        let prefetcher = ImagePrefetcher(urls: urls)
        prefetcher.start()
    }
}
