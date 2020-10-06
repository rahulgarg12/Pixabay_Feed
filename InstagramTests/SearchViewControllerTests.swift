//
//  SearchViewControllerTests.swift
//  InstagramTests
//
//  Created by Rahul Garg on 07/10/20.
//

import XCTest
@testable import Instagram

class SearchViewControllerTests: XCTestCase {
    
    var searchVC: SearchViewController!
    
    override func setUp() {
        super.setUp()
        
        searchVC = SearchViewController(nibName: SearchViewController.className, bundle: nil)
        searchVC.viewModel = SearchViewModel()
        searchVC.loadViewIfNeeded()
    }
    
    override func tearDown() {
        searchVC = nil
        super.tearDown()
    }
    
    func testViewController() {
        XCTAssertNotNil(searchVC, "No View Controller Available")
    }
    
    func testTableView() {
        XCTAssertNotNil(searchVC.tableView, "View Controller should have a tableview")
    }
    
    func testTableViewDelegate() {
        XCTAssertNotNil(searchVC.tableView.delegate, "TableView should have a delegate")
    }
    
    func testTableViewDatasource() {
        XCTAssertNotNil(searchVC.tableView.dataSource, "TableView should have a datasource")
    }
    
    func testSearchResultController() {
        XCTAssertNotNil(searchVC.searchController, "Search Controller is nil")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}


