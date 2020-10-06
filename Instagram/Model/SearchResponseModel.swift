//
//  SearchResponseModel.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import Foundation

struct SearchResponseModel: Codable {
    let total: Int
    let totalHits: Int
    let hits: [HitModel]
}
