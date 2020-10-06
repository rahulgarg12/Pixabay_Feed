//
//  BookmarkedViewControllerTests.swift
//  InstagramTests
//
//  Created by Rahul Garg on 06/10/20.
//

import XCTest
@testable import Instagram

class BookmarkedViewControllerTests: XCTestCase {
    
    var bookmarkVC: BookmarkedViewController!
    
    override func setUp() {
        super.setUp()
        
        bookmarkVC = BookmarkedViewController(nibName: BookmarkedViewController.className, bundle: nil)
        bookmarkVC.viewModel = BookmarkedViewModel()
        
        bookmarkVC.loadViewIfNeeded()
    }
    
    override func tearDown() {
        bookmarkVC = nil
        super.tearDown()
    }
    
    func testViewController() {
        XCTAssertNotNil(bookmarkVC, "No View Controller Available")
    }
    
    func testTableView() {
        XCTAssertNotNil(bookmarkVC.tableView, "View Controller should have a tableview")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(bookmarkVC.tableView.delegate, "TableView should have a delegate")
    }
    
    func testTableViewDatasource() {
        XCTAssertNotNil(bookmarkVC.tableView.dataSource, "TableView should have a datasource")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
