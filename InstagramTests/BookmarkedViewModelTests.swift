//
//  BookmarkedViewModelTests.swift
//  InstagramTests
//
//  Created by Rahul Garg on 06/10/20.
//

import XCTest
@testable import Instagram

class BookmarkedViewModelTests: XCTestCase {
    
    var bookmarkedModel: BookmarkedViewModel!
    
    override func setUp() {
        super.setUp()
        
        bookmarkedModel = BookmarkedViewModel()
    }
    
    func testGetAllBookmark() {
        XCTAssertNotNil(bookmarkedModel.getAllBookmarks(), "Get All Bookmarks error")
    }
    
    override func tearDown() {
        bookmarkedModel = nil
        super.tearDown()
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
