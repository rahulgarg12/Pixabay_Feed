//
//  FontTests.swift
//  InstagramTests
//
//  Created by Rahul Garg on 07/10/20.
//

import XCTest
@testable import Instagram

class FontTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBlackFont() {
        XCTAssertNotNil(UIFont.font(type: .black, size: FontSize.name.rawValue), "Black Font is not Available")
    }
    
    func testBoldFont() {
        XCTAssertNotNil(UIFont.font(type: .bold, size: FontSize.name.rawValue), "Bold Font is not Available")
    }
    
    func testHeavyFont() {
        XCTAssertNotNil(UIFont.font(type: .heavy, size: FontSize.name.rawValue), "Heavy Font is not Available")
    }
    
    func testLightFont() {
        XCTAssertNotNil(UIFont.font(type: .light, size: FontSize.name.rawValue), "Light Font is not Available")
    }
    
    func testRegularFont() {
        XCTAssertNotNil(UIFont.font(type: .regular, size: FontSize.name.rawValue), "Regular Font is not Available")
    }
    
    func testMediumFont() {
        XCTAssertNotNil(UIFont.font(type: .medium, size: FontSize.name.rawValue), "Medium Font is not Available")
    }
    
    func testSemiboldFont() {
        XCTAssertNotNil(UIFont.font(type: .semibold, size: FontSize.name.rawValue), "Semibold Font is not Available")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}



