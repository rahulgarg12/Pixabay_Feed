//
//  HitModelTests.swift
//  InstagramTests
//
//  Created by Rahul Garg on 06/10/20.
//

import XCTest
@testable import Instagram

class HitModelTests: XCTestCase {
    
    var hitModel: HitModel!
    
    override func setUp() {
        super.setUp()
        
        hitModel = HitModel()
    }
    
    override func tearDown() {
        hitModel = nil
        super.tearDown()
    }
    
    func testModel() {
        XCTAssertNotNil(hitModel, "timestamp default value missing")
    }
    
    func testTimestamp() {
        XCTAssertNotNil(hitModel.timestamp, "timestamp default value missing")
    }
    
    func testIsBookmark() {
        XCTAssertNotNil(hitModel.isBookmark, "isBookmark default value missing")
    }
    
    func testIsBookmarkFalse() {
        XCTAssert(hitModel.isBookmark == false, "isBookmark default value is not false")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
