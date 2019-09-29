

@testable import MBlogging
import XCTest

class AuthorListInteractorTests: XCTestCase
{
  // MARK: - Subject under test
  
  var interactorUnderTest: AuthorListInteractor!
  
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupAuthorListInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupAuthorListInteractor()
  {
    interactorUnderTest = AuthorListInteractor()
  }
  
  // MARK: - Test doubles
  
  class AuthorListPresentationLogicSpy: AuthorListPresentationLogic
  {
    
    
    // MARK: Method call expectations
    
    var presentAuthorListCalled = false
    
    // MARK: Spied methods
    
    func presentAuthorList(response: AuthorList.FetchAuthorList.Response) {
       
        presentAuthorListCalled = true
    }
  }
  
  class AuthorsWorkerSpy: AuthorListWorker
  {
    // MARK: Method call expectations
    
    var fetchAuthorsCalled = false
    
    // MARK: Spied methods
    
    override func fetchAuthorList(url: String, pageNumber: Int, completionHandler: @escaping ([Author]?, MBError?) -> Void)
    {
        fetchAuthorsCalled = true
        completionHandler([Seeds.Authors.firstAuthor , Seeds.Authors.secondAuthor], nil)
    }
    
  }
  
  // MARK: - Tests
    
    func testFetchOrdersShouldAskOrdersWorkerToFetchOrdersAndPresenterToFormatResult()
    {
        // Given
        let authorPresentationLogicSpy = AuthorListPresentationLogicSpy()
        interactorUnderTest.presenter = authorPresentationLogicSpy
        let authorsWorkerSpy = AuthorsWorkerSpy.init()
        interactorUnderTest.worker = authorsWorkerSpy
        
        // When
        let request = AuthorList.FetchAuthorList.Request.init(pageNumber: 1, urlToRequest: "sampleURL")
        interactorUnderTest.fetchAuthors(request: request)
        
        // Then
        XCTAssert(authorsWorkerSpy.fetchAuthorsCalled, "fetchAuthorsCalled() should ask AuthorWorker to fetch Authors")
        XCTAssert(authorPresentationLogicSpy.presentAuthorListCalled, "FetchAuthors() should ask presenter to show author result")
    }
 
}
