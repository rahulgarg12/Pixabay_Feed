//
//  SearchModel.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import Foundation

struct SearchModel: Codable {
    let key: String
    let q: String
    let page: Int
}
