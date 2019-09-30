//
//  StringShortcutTest.swift
//  MBloggingTests
//
//  Created by Sujata Chakraborty on 28/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

@testable import MBlogging
import XCTest

class UtilityClassTest: XCTestCase {

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


    
    func testStringtoDateConversion()
    {
        let dateFormatterInstance = DateFormatter()
        let inputDate = Seeds.UtilityTest.stringDateInput
        
        dateFormatterInstance.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatterInstance.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatterInstance.date(from:inputDate)  ?? Date()
        
        XCTAssertTrue(UtilityClass.stringToDateFormat(dateInString: inputDate) == date, "dates are not same")
    }
    
    
    func testdateToModifiedFormatInString()
    {
        let inputDate = Seeds.UtilityTest.stringDateInput
        let dateValue = UtilityClass.stringToDateFormat(dateInString: inputDate)
        let dateStringRoTest = UtilityClass.dateToStringFormat(date: dateValue ?? Date())

        XCTAssertTrue(dateStringRoTest == Seeds.UtilityTest.modifiedDate, "String format or value is not proper")
    }

}
