//
//  BaseWorkerTest.swift
//  MBloggingTests
//
//  Created by Sujata Chakraborty on 29/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//
@testable import MBlogging

import XCTest

class BaseWorkerTest: XCTestCase {
    
    // MARK: - Subject under test

    var workerUnderTest : BaseWorkerClass!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setupBaseWorkerClass()
    }
    
    func setupBaseWorkerClass()
    {
        workerUnderTest = BaseWorkerClass()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testQueryStringBuildAccordingToSortOrder() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let ascQueryString  =  workerUnderTest.fetchRequestQueryParameterFor(order: .ascending)
        let descQueryString = workerUnderTest.fetchRequestQueryParameterFor(order: .decending)

        XCTAssertTrue(ascQueryString == Seeds.Order.ascOrderQueryStr,   "Query string for ascending order string is not matching")
        XCTAssertTrue(descQueryString == Seeds.Order.descOrderQueryStr,   "Query string for descening order string is not matching")

    }



}
