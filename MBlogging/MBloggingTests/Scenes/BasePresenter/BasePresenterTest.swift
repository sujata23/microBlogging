//
//  BasePresenterTest.swift
//  MBloggingTests
//
//  Created by Sujata Chakraborty on 30/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

@testable import MBlogging

import XCTest

class BasePresenterTest: XCTestCase {
    
    // MARK: - Subject under test
    
    var presenterUnderTest : BasePresenterClass!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setUpBasePresenter()
    }
    
    func setUpBasePresenter()
    {
        presenterUnderTest = BasePresenterClass()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    
    func testdateModificationForBlankDateString() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
       let outputDateStr = presenterUnderTest.dateModification(sourceDate: "     ")
        
        XCTAssertTrue(outputDateStr == "",   "Blank string it should return for blank input date staring")
        
    }
    
    func testdateModificationFornilDateString() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let outputDateStr = presenterUnderTest.dateModification(sourceDate:nil)
        
        XCTAssertTrue(outputDateStr == "",   "Blank string it should return in case of nil input")
        
    }
    
    func testdateModificationForCorrectDateString() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let outputDateStr = presenterUnderTest.dateModification(sourceDate:Seeds.UtilityTest.stringDateInput)
        
        XCTAssertTrue(outputDateStr == Seeds.UtilityTest.modifiedDate,   "Blank string it should return date format in  this format Dec 5, 2017")
        
    }
    
    
    
}
