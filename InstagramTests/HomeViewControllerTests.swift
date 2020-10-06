//
//  HomeViewControllerTests.swift
//  InstagramTests
//
//  Created by Rahul Garg on 06/10/20.
//

import UIKit
import XCTest
@testable import Instagram

class HomeViewControllerTests: XCTestCase {
    
    var homeVC: HomeViewController!
    
    override func setUp() {
        super.setUp()
        
        let vc = HomeViewController(nibName: HomeViewController.className, bundle: nil)
        homeVC = vc
    }
    
    override func tearDown() {
        homeVC = nil
        super.tearDown()
    }
    
    func testViewController() {
        XCTAssertNotNil(homeVC, "No View Controller Available")
    }
    
    func testTableView() {
        XCTAssertNotNil(homeVC.bookmarkedViewController, "Bookmark View Controller is nil")
    }
    
    func testFeedViewController() {
        XCTAssertNotNil(homeVC.feedViewController, "Feed View Controller is nil")
    }
    
    func testSearchResultController() {
        XCTAssertNotNil(homeVC.searchController, "Search Controller is nil")
    }
    
    func testBlackColor() {
        XCTAssertNotNil(UIColor.appBlack, "TableView should have a datasource")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

