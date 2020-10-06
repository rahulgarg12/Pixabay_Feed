//
//  Constants.swift
//  Instagram
//
//  Created by Rahul Garg on 06/10/20.
//

import Foundation

struct Network {
    struct APIConstants {
        static let pixabayAPIKey = "16999828-e751750c88a249b6598bf1604"
    }
    
    struct APIKey {
        static let key = "key"
        static let query = "q"
        static let page = "page"
    }
}

struct UIViewTitles {
    struct Home {
        static let searchPlaceholder = "Search"
        static let headingTitle = "Home"
    }
    
    struct Bookmark {
        static let noItemMessage = "Nothing to show here"
    }
    
    struct Feed {
        static let refreshControlTitle = "Pull to refresh"
        static let noItemMessage = "Nothing to show here"
    }
    
    struct Search {
        static let searchPlaceholder = "Search"
        static let headingTitle = "Search"
    }
}

struct StoryboardIdentifier {
    let main = "Main"
}
