//
//  HitModel.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import Foundation
import RealmSwift

final class HitModel: Object, Codable{
    @objc dynamic var id: Int = 0
    @objc dynamic var pageURL: String?
    @objc dynamic var type: String?
    @objc dynamic var previewURL: String?
    @objc dynamic var userImageURL: String?
    @objc dynamic var largeImageURL: String?
    @objc dynamic var user: String?
    @objc dynamic var tags: String?
    
    @objc dynamic var timestamp: Double = 0
    @objc dynamic var isBookmark: Bool = false
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case pageURL
        case type
        case previewURL
        case userImageURL
        case largeImageURL
        case user
        case tags
    }
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
