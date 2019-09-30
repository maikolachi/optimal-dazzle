//
//  MasterViewModelTests.swift
//  Optimal DazzleTests
//
//  Created by Faisal Bhombal on 9/30/19.
//  Copyright © 2019 Bhombal. All rights reserved.
//

import XCTest
@testable import Optimal_Dazzle

class MasterViewModelTests: XCTestCase {

    var masterViewModel = MasterViewViewModel()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /***
        Ensure that all images exist in the cloud
     */
    func testEValidateImageUrls() {
    
        let expectation = XCTestExpectation(description: "Donload events for search criteria 'a'")
        
        self.masterViewModel.result(forQuery: "a") { (queryName) in
            
            for e in self.masterViewModel.events {
                assert(e.primaryPeformerImageUrl != nil, "No image url provided or null provided for Event: \(e.title) (\(e.id))")
            }
            expectation.fulfill()
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
