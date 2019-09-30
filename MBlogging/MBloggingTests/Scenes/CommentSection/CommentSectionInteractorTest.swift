//
//  CommentSectionInteractorClass.swift
//  MBloggingTests
//
//  Created by Sujata Chakraborty on 30/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//
@testable import MBlogging
import XCTest

class CommentSectionInteractorTest: XCTestCase {

    
    // MARK: - Subject under test
    
    var interactorUnderTest: CommentSectionInteractor!
    
    
    override func setUp() {
        
        super.setUp()
        setupCommentListInteractor()
    }
    
    // MARK: - Test setup
    
    func setupCommentListInteractor()
    {
        interactorUnderTest = CommentSectionInteractor()
    }

    
    // MARK: - Test doubles
    
    class CommentListPresentationLogicSpy: CommentSectionPresentationLogic
    {
        var presentReferentPostCalled = false
        
        var presentCommentListCalled = false
        
        func presentPost(response: CommentSection.FetchReferencePost.Response) {
            
            presentReferentPostCalled = true
        }
        
        func presentCommentList(response: CommentSection.FetchCommentList.Response) {
            
            presentCommentListCalled = true
        }
        
    }
    
    class CommentWorkerSpy: CommentSectionWorker
    {
        // MARK: Method call expectations
        
        var fetchCommentListCalled = false
        
        // MARK: Spied methods
        
        override func fetchComments(url: String, pageNumber: Int?, postId: String, sortOrder: SortOrder, completionHandler: @escaping ([Comment]?, MBError?) -> Void) {
            
            fetchCommentListCalled = true
            completionHandler([Seeds.Comments.firstComment , Seeds.Comments.secondComment], nil)
        }
        
    }
    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Tests
    
    func testGetReferencePostShouldAskPresenterToFormatResult()
    {
        // Given
        let commentPresentationspy = CommentListPresentationLogicSpy()
        interactorUnderTest.presenter = commentPresentationspy
        interactorUnderTest.referencePost = Seeds.Posts.firstPost
        
        // When
        let request = CommentSection.FetchReferencePost.Request()
        interactorUnderTest.getReferencePost(request: request)
        
        // Then
        XCTAssert(commentPresentationspy.presentReferentPostCalled, "getreferencePost() should ask presenter to format the Post details")
    }
    
    func testFetchCommentListShouldAskPresenterToFormatResult()
    {
        // Given
        interactorUnderTest.referencePost = Seeds.Posts.firstPost
        let commentPresentationspy = CommentListPresentationLogicSpy()
        interactorUnderTest.presenter = commentPresentationspy
        let commentWorkerSpy = CommentWorkerSpy.init()
        interactorUnderTest.worker = commentWorkerSpy
        
        // When
        let request = CommentSection.FetchCommentList.Request(postId: String(interactorUnderTest.referencePost.id))
        interactorUnderTest.fetchCommentDetails(request: request, order: .ascending, pageNumber: 1)
        
        // Then
        XCTAssert(commentWorkerSpy.fetchCommentListCalled, "fetchcommentlist() should ask commentListWorker to fetch comment")
        XCTAssert(commentPresentationspy.presentCommentListCalled, "presentcommenttList() should ask presenter to show comment list result")
    }
    
    

}
