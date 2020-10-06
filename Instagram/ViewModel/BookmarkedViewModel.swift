//
//  BookmarkedViewModel.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import Foundation
import RealmSwift

final class BookmarkedViewModel {
    var hits: Results<HitModel>?
    
    func getAllBookmarks() -> Results<HitModel> {
        return DatabaseHandler().getAllBookmarks()
    }
}
