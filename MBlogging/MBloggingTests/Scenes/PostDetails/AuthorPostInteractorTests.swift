

@testable import MBlogging
import XCTest

class AuthorPostInteractorTests: XCTestCase
{
  // MARK: - Subject under test
  
  var interactorUnderTest: AuthorPostDetailsInteractor!
  
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupAuthorPostListInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupAuthorPostListInteractor()
  {
    interactorUnderTest = AuthorPostDetailsInteractor()
  }
  
  // MARK: - Test doubles
  
  class AuthorPostListPresentationLogicSpy: AuthorPostDetailsPresentationLogic
  {
    
    var presentAuthorDetailsCalled = false

    var presentPostListCalled = false

    
    func presentAuthor(response:  AuthorPostDetails.FetchAuthorDetails.Response)
    {
       presentAuthorDetailsCalled = true
    }
    
    func presentPostList(response: AuthorPostDetails.FetchPostDetails.Response)
    {
        presentPostListCalled = true
    }
  }
  
  class AuthorsPostWorkerSpy: AuthorPostDetailsWorker
  {
    // MARK: Method call expectations
    
    var fetchPostListCalled = false
    
    // MARK: Spied methods
    override func fetchPostDetails(url : String , authorID : String,completionHandler: @escaping (_: [Post]?, _: MBError?) -> Void)
    {
        fetchPostListCalled = true
        completionHandler([Seeds.Posts.firstPost , Seeds.Posts.secondPost], nil)

    }

    
  }
  
  // MARK: - Tests
    
    func testGetAuthorDetailsShouldAskPresenterToFormatResult()
    {
        // Given
        let authorDetailsPresentationspy = AuthorPostListPresentationLogicSpy()
        interactorUnderTest.presenter = authorDetailsPresentationspy
        interactorUnderTest.author = Seeds.Authors.firstAuthor
        
        // When
        let request = AuthorPostDetails.FetchAuthorDetails.Request()
        interactorUnderTest.getAuthorDetails(request: request)
        
        // Then
        XCTAssert(authorDetailsPresentationspy.presentAuthorDetailsCalled, "getAuthorDetails() should ask presenter to format the Author details")
    }
    
    func testFetchPostDetailsShouldAskPresenterToFormatResult()
    {
        // Given
        interactorUnderTest.author = Seeds.Authors.secondAuthor
        let postPresentationLogicSpy = AuthorPostListPresentationLogicSpy()
        interactorUnderTest.presenter = postPresentationLogicSpy
        let postWorkerSpy = AuthorsPostWorkerSpy.init()
        interactorUnderTest.worker = postWorkerSpy

        // When
        let request = AuthorPostDetails.FetchPostDetails.Request(authorId: String(interactorUnderTest.author.id))
        interactorUnderTest.fetchPostDetails(request: request)

        // Then
        XCTAssert(postWorkerSpy.fetchPostListCalled, "fetchPostDetails() should ask PostListWorker to fetch Posts")
        XCTAssert(postPresentationLogicSpy.presentPostListCalled, "presentPostList() should ask presenter to show Post list result")
    }
 
}
