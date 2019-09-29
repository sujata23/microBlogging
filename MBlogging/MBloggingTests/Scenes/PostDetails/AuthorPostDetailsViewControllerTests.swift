//
//  AuthorListViewControllerTests.swift
//  MBloggingTests
//
//  Created by Sujata Chakraborty on 28/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

@testable import MBlogging

import XCTest

class AuthorPostDetailsViewControllerTests: XCTestCase {
    
    var currentControllerUnderTest : AuthorPostDetailsViewController!
    var window: UIWindow!
    
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupListAuthorsViewController()
        
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    func setupListAuthorsViewController()
    {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        currentControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "AuthorPostDetailsViewController") as? AuthorPostDetailsViewController
    }
    
    func loadView()
    {
        window.addSubview(currentControllerUnderTest.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Test doubles
    
    class PostDetailsBusinessLogicSpy: AuthorPostDetailsBusinessLogic , AuthorPostDetailsDataStore
    {

        var author: Author!
        
    
        // MARK: Method call expectations
        
        var fetchAuthorCalled = false
        var fetchPostCalled = false
        
        // MARK: Spied methods

        func getAuthorDetails(request: AuthorPostDetails.FetchAuthorDetails.Request) {
            fetchAuthorCalled = true
        }
        
        func fetchPostDetails(request: AuthorPostDetails.FetchPostDetails.Request , order: SortOrder) {
            fetchPostCalled = true
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
    
    func testShouldFetchAuthorsWhenViewDidLoad()
    {
        // Given
        let authorBusinessLogicSpy = PostDetailsBusinessLogicSpy()
        currentControllerUnderTest.interactor = authorBusinessLogicSpy
        loadView()
        
        // When
        currentControllerUnderTest.viewDidLoad()
        
        // Then
        XCTAssert(authorBusinessLogicSpy.fetchAuthorCalled, "Should fetch authors right after the view did loaded")
    }
    
    func testShouldFetchAuthorsWhenAuthorIsLoaded()
    {
        // Given
        let authorsPostBusinessLogicSpy = PostDetailsBusinessLogicSpy()
        currentControllerUnderTest.interactor = authorsPostBusinessLogicSpy
        loadView()
        
        // When
        let displayedAuthor = AuthorPostDetails.FetchAuthorDetails.ViewModel.DisplayAuthor(id: "1", name: "TestAuthor1", userName: "TestAuthor1UN", email: "testauthor1@testemailid.com", avatarUrl: "testURL")
        
        let viewModel = AuthorPostDetails.FetchAuthorDetails.ViewModel(authorDetails: displayedAuthor)
        currentControllerUnderTest.displayAuthorDetails(viewModel: viewModel)
        
        // Then
        XCTAssert(authorsPostBusinessLogicSpy.fetchPostCalled, "Should fetch Posts for selected user")
    }
    
    func testTableViewShouldReloadWhenAuthorDataIsFetched()
    {
        // Given
        let tableViewSpy = TableViewSpy()
        currentControllerUnderTest.tableView = tableViewSpy
        
        // When
        let displayedAuthor = AuthorPostDetails.FetchAuthorDetails.ViewModel.DisplayAuthor(id: "1", name: "TestAuthor1", userName: "TestAuthor1UN", email: "testauthor1@testemailid.com", avatarUrl: "testURL")
        
        let viewModel = AuthorPostDetails.FetchAuthorDetails.ViewModel(authorDetails: displayedAuthor)
        currentControllerUnderTest.displayAuthorDetails(viewModel: viewModel)
        
        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying Author details on table header")
    }
    
    func testShouldDisplayFetchedPost()
    {
        // Given
        let tableViewSpy = TableViewSpy()
        currentControllerUnderTest.tableView = tableViewSpy

        // When
        let displayedPost = [AuthorPostDetails.FetchPostDetails.ViewModel.DisplayedPost(title: "Test post title", date: Seeds.UtilityTest.stringDateInput, body: "Test body input")]

        let viewModel = AuthorPostDetails.FetchPostDetails.ViewModel(postList: displayedPost)
        currentControllerUnderTest.displayPostDetails(viewModel: viewModel)

        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched Posts should reload the table view")
    }

    
    func testNumberOfRowsInAnySectionShouldEqaulNumberOfAuthorsToDisplay()
    {
        // Given
        let authorsPostBusinessLogicSpy = PostDetailsBusinessLogicSpy()
        currentControllerUnderTest.interactor = authorsPostBusinessLogicSpy
        authorsPostBusinessLogicSpy.author = Seeds.Authors.firstAuthor
        
        let tableView = currentControllerUnderTest.tableView
        let displayedPost = [AuthorPostDetails.FetchPostDetails.ViewModel.DisplayedPost(title: "Test post title", date: Seeds.UtilityTest.stringDateInput, body: "Test body input")]
        currentControllerUnderTest.displayedPostList = displayedPost

        // When
        let numberOfRows = currentControllerUnderTest.tableView(tableView!, numberOfRowsInSection: 0)

        // Then
        XCTAssertEqual(numberOfRows, displayedPost.count, "The number of table view rows should equal the number of posts to display")
    }
    
    
    func testShouldConfigureTableViewHeaderToDisplayAuthorDetails()
    {
        // Given
        let authorsPostBusinessLogicSpy = PostDetailsBusinessLogicSpy()
        currentControllerUnderTest.interactor = authorsPostBusinessLogicSpy
        authorsPostBusinessLogicSpy.author = Seeds.Authors.firstAuthor
        
        let tableView = currentControllerUnderTest.tableView
        
        
        let displayedPost = [AuthorPostDetails.FetchPostDetails.ViewModel.DisplayedPost(title: "Test post title", date: Seeds.UtilityTest.modifiedDate, body: "Test body input")]
        currentControllerUnderTest.displayedPostList = displayedPost
        
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = currentControllerUnderTest.tableView(tableView!, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.title.text, "Test post title", "A properly configured table view cell should display the post title")
        XCTAssertEqual(cell.date?.text, Seeds.UtilityTest.modifiedDate, "A properly configured table view cell should display the authors emailid")
        XCTAssertEqual(cell.postBody?.text, "Test body input", "A properly configured table view cell should display the authors post body")
        
    }

    func testShouldConfigureTableViewCellToDisplayPosts()
    {
        // Given
        let authorsPostBusinessLogicSpy = PostDetailsBusinessLogicSpy()
        currentControllerUnderTest.interactor = authorsPostBusinessLogicSpy
        authorsPostBusinessLogicSpy.author = Seeds.Authors.firstAuthor
        
        let tableView = currentControllerUnderTest.tableView
        
        // When
        let displayedAuthor = AuthorPostDetails.FetchAuthorDetails.ViewModel.DisplayAuthor(id: String(Seeds.Authors.firstAuthor.id), name: Seeds.Authors.firstAuthor.name, userName: Seeds.Authors.firstAuthor.userName, email: Seeds.Authors.firstAuthor.email, avatarUrl: Seeds.Authors.firstAuthor.avatarUrl)
        let viewModel = AuthorPostDetails.FetchAuthorDetails.ViewModel(authorDetails: displayedAuthor)
        currentControllerUnderTest.displayAuthorDetails(viewModel: viewModel)
        let headerView = currentControllerUnderTest.tableView(tableView!, viewForHeaderInSection: 0)
        
        // Then
        XCTAssertEqual(headerView?.authorName.text, "authorFirst", "A properly configured table view cell should display the post title")
        XCTAssertEqual(headerView?.authorEmailId?.text, "author.first@email.id", "A properly configured table view cell should display the authors emailid")

    }
}
