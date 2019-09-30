//
//  CommentSectionViewControllerTestd.swift
//  MBloggingTests
//
//  Created by Sujata Chakraborty on 30/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

@testable import MBlogging
import XCTest

class CommentSectionViewControllerTests: XCTestCase {
    
    var currentControllerUnderTest : CommentSectionViewController!
    var window: UIWindow!


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        window = UIWindow()
        setupListAuthorViewController()
    }

    
    func setupListAuthorViewController()
    {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        currentControllerUnderTest = storyboard.instantiateViewController(withIdentifier: "CommentSectionViewController") as? CommentSectionViewController
    }
    
    func loadView()
    {
        window.addSubview(currentControllerUnderTest.view)
        RunLoop.current.run(until: Date())
    }
    
    
    // MARK: - Test doubles
    
    class CommentBusinessLogicSpy: CommentSectionBusinessLogic
    {
        
        // MARK: Method call expectations
        
        var fetchPostCalled = false
        var fetchCommentCalled = false

        
        func getReferencePost(request: CommentSection.FetchReferencePost.Request) {
            
           fetchPostCalled = true

        }
        
        func fetchCommentDetails(request: CommentSection.FetchCommentList.Request, order: SortOrder, pageNumber: Int) {
        
            fetchCommentCalled = true
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
    
    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Tests
    
    func testShouldFetchReferenceWhenViewDidLoad()
    {
        // Given
        let postBusinessLogicSpy = CommentBusinessLogicSpy()
        currentControllerUnderTest.interactor = postBusinessLogicSpy
        loadView()
        
        // When
        currentControllerUnderTest.viewDidLoad()
        
        // Then
        XCTAssert(postBusinessLogicSpy.fetchPostCalled, "Should fetch post right after the view did loaded")
    }
    
    func testShouldFetchCommentWhenPostIsLoaded()
    {
        // Given
        let postBusinessLogicSpy = CommentBusinessLogicSpy()
        currentControllerUnderTest.interactor = postBusinessLogicSpy
        loadView()
        
        // When
        let displayedPost = CommentSection.FetchReferencePost.ViewModel.DisplayPost.init(id: "1")
        
        let viewModel = CommentSection.FetchReferencePost.ViewModel(postInfo: displayedPost)
        currentControllerUnderTest.displayReferencePost(viewModel: viewModel)
        
        // Then
        XCTAssert(postBusinessLogicSpy.fetchCommentCalled, "Should fetch Comments for selected Post")
    }
    

    func testShouldDisplayFetchedComment()
    {
        // Given
        let tableViewSpy = TableViewSpy()
        currentControllerUnderTest.tableView = tableViewSpy

        // When
        let displayedComment = [CommentSection.FetchCommentList.ViewModel.DisplayedComment.init(userName: "testCommenter", date: Seeds.UtilityTest.stringDateInput, body: "This is a test comment", avatarUrl: "demo url")]

        let viewModel = CommentSection.FetchCommentList.ViewModel(commentList: displayedComment)
        currentControllerUnderTest.displayCommentList(viewModel: viewModel)

        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched comment on selected post should reload the table view")
    }

    
    func testNumberOfRowsInAnySectionShouldEqaulNumberOfAuthorsToDisplay()
    {
        // Given
        let commentBusinessLogicSpy = CommentBusinessLogicSpy()
        currentControllerUnderTest.interactor = commentBusinessLogicSpy

        let tableView = currentControllerUnderTest.tableView
        let displayedComment = [CommentSection.FetchCommentList.ViewModel.DisplayedComment.init(userName: "testCommenter", date: Seeds.UtilityTest.stringDateInput, body: "This is a test comment", avatarUrl: "demo url")]
        currentControllerUnderTest.displayedComments = displayedComment

        // When
        let numberOfRows = currentControllerUnderTest.tableView(tableView!, numberOfRowsInSection: 0)

        // Then
        XCTAssertEqual(numberOfRows, displayedComment.count, "The number of table view rows should equal the number of commets to display")
    }



    
    func testShouldConfigureTableViewCellToDisplayComments()
    {
        // Given
        let commentPostBusinessLogicSpy = CommentBusinessLogicSpy()
        currentControllerUnderTest.interactor = commentPostBusinessLogicSpy

        let tableView = currentControllerUnderTest.tableView

        // When
        let displayedComment = [CommentSection.FetchCommentList.ViewModel.DisplayedComment.init(userName: "testCommenter", date: Seeds.UtilityTest.modifiedDate, body: "This is a test comment", avatarUrl: "demo url")]
        let viewModel = CommentSection.FetchCommentList.ViewModel(commentList: displayedComment)
        currentControllerUnderTest.displayCommentList(viewModel: viewModel)
        let cell = currentControllerUnderTest.tableView(tableView!, cellForRowAt: IndexPath.init(row: 0, section: 0))

        // Then
        XCTAssertEqual(cell.userName.text, "testCommenter", "A properly configured table view cell should display the post user name")
        XCTAssertEqual(cell.date.text, Seeds.UtilityTest.modifiedDate, "A properly configured table view cell should display the post date")
        XCTAssertEqual(cell.postBody.text, "This is a test comment", "A properly configured table view cell should display the post body")

    }

}
