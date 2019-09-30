//
//  StringShortcutTest.swift
//  MBloggingTests
//
//  Created by Sujata Chakraborty on 28/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

@testable import MBlogging
import XCTest

class StringShortcutTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        super.tearDown()
    }


    
    func testStringTrimFunction()
    {
        let stringwithSpaces = "   stringwithBlankAtStartAndBack   "
        
        XCTAssertTrue(stringwithSpaces.trim() == "stringwithBlankAtStartAndBack", "the spaces at front and back should be trimmed")
    }

}
