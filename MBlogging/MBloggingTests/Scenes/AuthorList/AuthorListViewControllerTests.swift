//
//  AuthorListViewControllerTests.swift
//  MBloggingTests
//
//  Created by Sujata Chakraborty on 27/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

@testable import MBlogging

import XCTest

class AuthorListViewControllerTests: XCTestCase {
    
    var currentControllerUnderTest : AuthorListViewController!
    var window: UIWindow!
    
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupListAuthorViewController()
        
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    func setupListAuthorViewController()
    {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        currentControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "AuthorListViewController") as? AuthorListViewController
    }
    
    func loadView()
    {
        window.addSubview(currentControllerUnderTest.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Test doubles
    
    class AuthorListBusinessLogicSpy: AuthorListBusinessLogic
    {
        
        var authors: [Author]?
        
        // MARK: Method call expectations
        
        var fetchAuthorsCalled = false
        
        // MARK: Spied methods
        func fetchAuthors(request: AuthorList.FetchAuthorList.Request) {
            fetchAuthorsCalled = true
        }
        
    }
    
    class TableViewSpy: UITableView
    {
        // MARK: Method call expectations
        
        var reloadDataCalled = false
        
        // MARK: Spied methods
        
        override func reloadData()
        {
            reloadDataCalled = true
        }
    }
    
    // MARK: - Tests
    
    func testShouldFetchAuthorsWhenViewDidAppear()
    {
        // Given
        let authorListBusinessLogicSpy = AuthorListBusinessLogicSpy()
        currentControllerUnderTest.interactor = authorListBusinessLogicSpy
        loadView()
        
        // When
        currentControllerUnderTest.viewWillAppear(true)
        
        // Then
        XCTAssert(authorListBusinessLogicSpy.fetchAuthorsCalled, "Should fetch authors right after the view appears")
    }
    
    func testShouldDisplayFetchedAuthors()
    {
        // Given
        let tableViewSpy = TableViewSpy()
        currentControllerUnderTest.tableView = tableViewSpy
        
        // When
        let displayedAuthors = [AuthorList.FetchAuthorList.ViewModel.DisplayAuthorList(name: "TestAuthor1", userName: "TestAuthor1UN", email: "testauthor1@testemailid.com", avatarUrl: "testURL")]
        
        let viewModel = AuthorList.FetchAuthorList.ViewModel(authorList: displayedAuthors)
        currentControllerUnderTest.displayAuthorList(viewModel: viewModel)
        
        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched Authors should reload the table view")
    }
    
    func testAfterFetchingCompleteDataNoMoreDataShouldFetch()
    {
        // Given
        let tableViewSpy = TableViewSpy()
        currentControllerUnderTest.tableView = tableViewSpy
        
        // When
        let error = MBError.init(mbErrorCode: .EmptyData)
        currentControllerUnderTest.errorReceivedInAuthorFetchRequest(error: error)
        
        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched Authors should  remo e loader cell")
        XCTAssertFalse(currentControllerUnderTest.isPaginationRequired, "No more pagination should happen")

    }
    
    func testErrorWhileFetchingAuthor()
    {
        // Given
        let tableViewSpy = TableViewSpy()
        currentControllerUnderTest.tableView = tableViewSpy
        
        // When
        let error = MBError.init(mbErrorCode: .GeneralError)
        currentControllerUnderTest.pageToBeFetched = 2
        currentControllerUnderTest.errorReceivedInAuthorFetchRequest(error: error)
        
        
        // Then
        XCTAssertFalse(tableViewSpy.reloadDataCalled, "Reload data should not get called")
        XCTAssertTrue(currentControllerUnderTest.pageToBeFetched == 1, "page number should decreasedagain")

    }
    
    func testErrorWhileFetchingAuthorForPageOne()
    {
        // Given
        let tableViewSpy = TableViewSpy()
        currentControllerUnderTest.tableView = tableViewSpy
        
        // When
        let error = MBError.init(mbErrorCode: .GeneralError)
        currentControllerUnderTest.errorReceivedInAuthorFetchRequest(error: error)
        
        
        // Then
        XCTAssertFalse(tableViewSpy.reloadDataCalled, "Reload data should not get called")
        XCTAssertTrue(currentControllerUnderTest.pageToBeFetched == 1, "page number should decreasedagain")
        
    }
    
   
    
    func testNumberOfRowsInAnySectionShouldEqaulNumberOfAuthorsToDisplay()
    {
        // Given
        let tableView = currentControllerUnderTest.tableView
        let testDisplayedAuthors = [AuthorList.FetchAuthorList.ViewModel.DisplayAuthorList(name: "TestAuthor1", userName: "TestAuthor1UN", email: "testauthor1@testemailid.com", avatarUrl: "testURL")]
        currentControllerUnderTest.displayedAuthors = testDisplayedAuthors
        
        // When
        let numberOfRows = currentControllerUnderTest.tableView(tableView!, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, testDisplayedAuthors.count, "The number of table view rows should equal the number of authors to display")
    }
    
    
    func testShouldConfigureTableViewCellToDisplayAuthor()
    {
        // Given
        let tableView = currentControllerUnderTest.tableView
        let testDisplayAuthor = [AuthorList.FetchAuthorList.ViewModel.DisplayAuthorList(name: "TestAuthor1", userName: "TestAuthor1UN", email: "testauthor1@testemailid.com", avatarUrl: "testURL")]

        currentControllerUnderTest.displayedAuthors = testDisplayAuthor
        
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = (currentControllerUnderTest.tableView(tableView!, cellForRowAt: indexPath)) as! AuthorListCell
        
        // Then
        XCTAssertEqual(cell.authorName?.text, "TestAuthor1", "A properly configured table view cell should display the authors name")
        XCTAssertEqual(cell.authorEmailId?.text, "testauthor1@testemailid.com", "A properly configured table view cell should display the authors emailid")
    }
}
