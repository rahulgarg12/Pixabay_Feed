//
//  SearchViewModelTests.swift
//  InstagramTests
//
//  Created by Rahul Garg on 06/10/20.
//

import XCTest
@testable import Instagram

class SearchViewModelTests: XCTestCase {
    
    var viewModel: SearchViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testResponseApi() {
        var apiResponse: SearchResponseModel?
        
        let exp = self.expectation(description: "myExpectation")
        
        let cancellable = viewModel.fetchData(query: "flower")
            .sink(receiveCompletion: { _ in }) { response in
                apiResponse = response
                exp.fulfill()
            }
        
        XCTAssertNotNil(cancellable, "Cancellable is nil")
        
        waitForExpectations(timeout: 15) { (error) in
            XCTAssertNotNil(apiResponse, "Response is nil")
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

