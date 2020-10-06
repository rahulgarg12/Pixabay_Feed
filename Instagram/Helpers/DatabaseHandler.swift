//
//  DatabaseHandler.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import RealmSwift

final class DatabaseHandler {
    
    static let serialQueue = DispatchQueue(label: "com.realm.serial")
    
    static func clearRealmData() {
        let realm = try? Realm()
        try? realm?.write {
            DatabaseHandler.serialQueue.sync {
                realm?.deleteAll()
            }
        }
    }
    
    static func refreshRealmData() {
        let realm = try? Realm()
        realm?.refresh()
    }
}


extension DatabaseHandler {
    func saveNewBookmark(model: HitModel) {
        autoreleasepool {
            let realm = try? Realm()
            try? realm?.write {
                if !model.isInvalidated {
                    DatabaseHandler.serialQueue.sync {
                        model.timestamp = Date().timeIntervalSince1970
                        model.isBookmark = true
                        
                        realm?.add(model)
                    }
                }
            }
        }
    }
    
    func getAllBookmarks(isOrderedByLatest: Bool = true) -> [HitModel] {
        autoreleasepool {
            let realm = try! Realm()

            let result = realm.objects(HitModel.self).filter("isBookmark == true")
            if isOrderedByLatest {
                return Array(result.sorted(byKeyPath: "timestamp", ascending: false))
            } else {
                return Array(result)
            }
        }
    }
    
    func getAllBookmarks(isOrderedByLatest: Bool = true) -> Results<HitModel> {
        autoreleasepool {
            let realm = try! Realm()
            
            let result = realm.objects(HitModel.self).filter("isBookmark == true")
            if isOrderedByLatest {
                return result.sorted(byKeyPath: "timestamp", ascending: false)
            } else {
                return result
            }
        }
    }
    
    func getBookmarkModel(for key: Int) -> HitModel? {
        autoreleasepool {
            let realm = try? Realm()
            return realm?.object(ofType: HitModel.self, forPrimaryKey: key)
        }
    }
    
    func updateTimestampFor(id: Int, timestamp: Double) {
        guard let model = getBookmarkModel(for: id) else { return }
        
        autoreleasepool {
            let realm = try? Realm()
            try? realm?.write {
                DatabaseHandler.serialQueue.sync {
                    model.timestamp = timestamp
                }
            }
        }
    }
    
    func updateBookmarkStatusFor(id: Int, status: Bool) {
        guard let model = getBookmarkModel(for: id) else { return }
        
        autoreleasepool {
            let realm = try? Realm()
            try? realm?.write {
                DatabaseHandler.serialQueue.sync {
                    model.isBookmark = status
                }
            }
        }
    }
    
    func updateBookmarkStatusFor(object: HitModel, status: Bool) {
        autoreleasepool {
            let realm = try? Realm()
            try? realm?.write {
                DatabaseHandler.serialQueue.sync {
                    object.isBookmark = status
                }
            }
        }
    }
    
    func perform(completion: () -> ()) {
        autoreleasepool {
            let realm = try? Realm()
            try? realm?.write {
                DatabaseHandler.serialQueue.sync {
                    completion()
                }
            }
        }
    }
    
    func toggleBookmarkStatusFor(object: HitModel) {
        autoreleasepool {
            let realm = try? Realm()
            try? realm?.write {
                DatabaseHandler.serialQueue.sync {
                    if !object.isInvalidated {
                        object.isBookmark = !object.isBookmark
                    }
                }
            }
        }
    }
    
    func deleteSearchModel(for key: Int) {
        guard let model = getBookmarkModel(for: key) else { return }
        
        autoreleasepool {
            let realm = try? Realm()
            try? realm?.write {
                DatabaseHandler.serialQueue.sync {
                    realm?.delete(model)
                }
            }
        }
    }
}
