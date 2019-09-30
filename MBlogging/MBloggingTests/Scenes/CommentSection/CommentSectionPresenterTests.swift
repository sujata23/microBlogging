//
//  CommentSectionPresenterTests.swift
//  MBloggingTests
//
//  Created by Sujata Chakraborty on 30/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

@testable import MBlogging
import XCTest

class CommentSectionPresenterTests: XCTestCase {

    // MARK: - Subject under test
    
    var presenterUnderTest : CommentSectionPresenter!
    
    
    override func setUp()
    {
        super.setUp()
        setupPostPresenter()
    }
    
    // MARK: - Test setup
    
    func setupPostPresenter()
    {
        presenterUnderTest = CommentSectionPresenter()
    }
    
    // MARK: - Test doubles
    
    class CommentDisplayLogicSpy: CommentSectionDisplayLogic
    {
        
        
        var presentPostCalled = false
        var presentCommentListCalled = false
        var errorCallBackForCommentListCalled = false
        
        var viewModelPost: CommentSection.FetchReferencePost.ViewModel!
        var viewModelComment: CommentSection.FetchCommentList.ViewModel!
        
        func displayReferencePost(viewModel: CommentSection.FetchReferencePost.ViewModel) {
           
            viewModelPost = viewModel
            presentPostCalled = true
        }
        
        func displayCommentList(viewModel: CommentSection.FetchCommentList.ViewModel) {
            
            viewModelComment = viewModel
            presentCommentListCalled = true
        }
        
        func errorReceivedInCommentFetchRequest(error: MBError) {
            
            errorCallBackForCommentListCalled = true
        }

    }
    
    
    // MARK: - Tests
    
    func testPresentDisplayedPostShouldFormatFetchedPostDisplay()
    {
        // Given
        let commentDisplayLogicSpy = CommentDisplayLogicSpy()
        presenterUnderTest.viewController = commentDisplayLogicSpy
        
        let firstPost = Seeds.Posts.firstPost
        
        
        let response = CommentSection.FetchReferencePost.Response(post: firstPost)
        presenterUnderTest.presentPost(response: response)
        
        // Then
        let displayedPost = commentDisplayLogicSpy.viewModelPost.postInfo
        
        XCTAssertEqual(displayedPost.id, "1", "Presenting fetched post should properly format post ID")
       
        
    }
    
    func testPresentDisplayedCommentShouldFormatFetchedCommentDisplay()
    {
        // Given
        let commentDisplayLogicSpy = CommentDisplayLogicSpy()
        presenterUnderTest.viewController = commentDisplayLogicSpy
        
        let comment = Seeds.Comments.firstComment
        
        let response = CommentSection.FetchCommentList.Response.init(commentList: [comment], error: nil)
        presenterUnderTest.presentCommentList(response: response)
        
        // Then
        let displayedComment = commentDisplayLogicSpy.viewModelComment.commentList
        
        for displayedEachComment in displayedComment
        {
            XCTAssertEqual(displayedEachComment.body, comment.body, "Presenting fetched comment should properly format pocommentst body")
            XCTAssertEqual(displayedEachComment.userName, comment.userName, "Presenting fetched comment should properly format comment title")
            XCTAssertEqual(displayedEachComment.date, "Dec 5, 2017", "Presenting fetched comment should properly format date")
            XCTAssertEqual(displayedEachComment.avatarUrl, comment.avatarUrl, "Presenting fetched comment should properly pass url ")

        }
        
    }
    
    
    func testPresentFetchedCommentlistShouldAskViewControllerToDisplayFetchedCommentlist()
    {
        // Given
        let commentDisplayLogicSpy = CommentDisplayLogicSpy()
        presenterUnderTest.viewController = commentDisplayLogicSpy
        
        // When
        let comment = Seeds.Comments.firstComment
        let response = CommentSection.FetchCommentList.Response(commentList: [comment], error: nil)
        presenterUnderTest.presentCommentList(response: response)
        
        // Then
        XCTAssertTrue(commentDisplayLogicSpy.presentCommentListCalled, "Presenting fetched comment should ask view controller to display them")
    }
    
    func testPresentFaultyFetchedCommentlistShouldAskViewControllerToDisplayError()
    {
        // Given
        let commentDisplayLogicSpy = CommentDisplayLogicSpy()
        presenterUnderTest.viewController = commentDisplayLogicSpy
        
        // When
        let testError = MBError.init(mbErrorCode: .GeneralError)
        
        let response = CommentSection.FetchCommentList.Response(commentList: nil, error: testError)
        presenterUnderTest.presentCommentList(response: response)
        
        // Then
        XCTAssertTrue(commentDisplayLogicSpy.errorCallBackForCommentListCalled, "Presenting fetched comment should ask view controller to display error")
    }
    
    

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

  

}
