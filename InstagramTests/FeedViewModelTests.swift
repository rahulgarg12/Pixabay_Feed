//
//  FeedViewModelTests.swift
//  InstagramTests
//
//  Created by Rahul Garg on 06/10/20.
//

import XCTest
@testable import Instagram

class FeedViewModelTests: XCTestCase {
    
    var viewModel: FeedViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = FeedViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testResponseApi() {
        var apiResponse: SearchResponseModel?
        
        let exp = self.expectation(description: "myExpectation")
        
        let cancellable = viewModel.fetchData()
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

