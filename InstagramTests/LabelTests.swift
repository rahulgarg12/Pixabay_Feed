//
//  LabelTests.swift
//  InstagramTests
//
//  Created by Rahul Garg on 07/10/20.
//

import XCTest
@testable import Instagram

class LabelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNameLabel() {
        XCTAssertNotNil(NameLabel(), "Name Label is not Available")
    }
    
    func testHeadingLabel() {
        XCTAssertNotNil(HeadingLabel(), "Heading Label is not Available")
    }
    
    func testLocationLabel() {
        XCTAssertNotNil(LocationLabel(), "Location Label is not Available")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}



