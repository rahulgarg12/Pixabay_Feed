//
//  FeedViewControllerTests.swift
//  InstagramTests
//
//  Created by Rahul Garg on 07/10/20.
//

import XCTest
@testable import Instagram

class FeedViewControllerTests: XCTestCase {
    
    var feedVC: FeedViewController!
    
    override func setUp() {
        super.setUp()
        
        feedVC = FeedViewController(nibName: FeedViewController.className, bundle: nil)
        feedVC.viewModel = FeedViewModel()
        feedVC.loadViewIfNeeded()
    }
    
    override func tearDown() {
        feedVC = nil
        super.tearDown()
    }
    
    func testViewController() {
        XCTAssertNotNil(feedVC, "No View Controller Available")
    }
    
    func testViewControllerTableView() {
        XCTAssertNotNil(feedVC.tableView, "View Controller should have a tableview")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(feedVC.tableView.delegate, "TableView should have a delegate")
    }
    
    func testTableViewDatasource() {
        XCTAssertNotNil(feedVC.tableView.dataSource, "TableView should have a datasource")
    }
    
    func testRefreshController() {
        XCTAssertNotNil(feedVC.refreshControl, "Refresh Controller is nil")
    }
    
    func testSpinner() {
        XCTAssertNotNil(feedVC.spinner, "Spinner is nil")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

