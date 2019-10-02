

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
    
    override func fetchAuthorList(url: String, pageNumber: Int, sortOrder: SortOrder, completionHandler: @escaping ([Author]?, MBError?) -> Void) {
        
        fetchAuthorsCalled = true
        completionHandler([Seeds.Authors.firstAuthor , Seeds.Authors.secondAuthor], nil)
    }
    
  }
    
    class AuthorsWorkerErrorSpy: AuthorListWorker
    {
        // MARK: Method call expectations
        
        var fetchAuthorsCalled = false
        
        // MARK: Spied methods
        
        override func fetchAuthorList(url: String, pageNumber: Int, sortOrder: SortOrder, completionHandler: @escaping ([Author]?, MBError?) -> Void) {
            
            fetchAuthorsCalled = true
            completionHandler([], nil)
        }
        
    }
    
    
    class AuthorsWorkerGeneralErrorSpy: AuthorListWorker
    {
        // MARK: Method call expectations
        
        var fetchAuthorsCalled = false
        
        // MARK: Spied methods
        
        override func fetchAuthorList(url: String, pageNumber: Int, sortOrder: SortOrder, completionHandler: @escaping ([Author]?, MBError?) -> Void) {
            
            fetchAuthorsCalled = true
            let error = MBError.init(mbErrorCode: .GeneralError)
            completionHandler(nil, error)
        }
        
    }
  
  // MARK: - Tests
    
    func testFetchAuthorsShouldAskAuthorWorkerToFetchAuthorAndPresenterToFormatResult()
    {
        // Given
        let authorPresentationLogicSpy = AuthorListPresentationLogicSpy()
        interactorUnderTest.presenter = authorPresentationLogicSpy
        let authorsWorkerSpy = AuthorsWorkerSpy.init()
        interactorUnderTest.worker = authorsWorkerSpy
        
        // When
        let request = AuthorList.FetchAuthorList.Request(pageNumber: 1, urlToRequest: "sampleURL", sortOrder: .ascending)
        interactorUnderTest.fetchAuthors(request: request)
        
        // Then
        XCTAssert(authorsWorkerSpy.fetchAuthorsCalled, "fetchAuthorsCalled() should ask AuthorWorker to fetch Authors")
        XCTAssert(authorPresentationLogicSpy.presentAuthorListCalled, "FetchAuthors() should ask presenter to show author result")
    }
    
    
    
    func testFetchAuthorsShouldAskAuthorWorkerToFetchAuthorAndPresenterToShowFullyLoadedData()
    {
        // Given
        let authorPresentationLogicSpy = AuthorListPresentationLogicSpy()
        interactorUnderTest.presenter = authorPresentationLogicSpy
        let authorsWorkerSpy = AuthorsWorkerErrorSpy.init()
        interactorUnderTest.worker = authorsWorkerSpy
        
        // When
        let request = AuthorList.FetchAuthorList.Request(pageNumber: 1, urlToRequest: "sampleURL", sortOrder: .ascending)
        interactorUnderTest.fetchAuthors(request: request)
        
        // Then
        XCTAssert(authorsWorkerSpy.fetchAuthorsCalled, "fetchAuthorsCalled() should ask AuthorWorker to fetch Authors")
        XCTAssert(authorPresentationLogicSpy.presentAuthorListCalled, "FetchAuthors() should ask presenter to show author result")
    }
    
    
    func testFetchAuthorsShouldAskAuthorWorkerToFetchAuthorAndPresenterToShowError()
    {
        // Given
        let authorPresentationLogicSpy = AuthorListPresentationLogicSpy()
        interactorUnderTest.presenter = authorPresentationLogicSpy
        let authorsWorkerSpy = AuthorsWorkerGeneralErrorSpy.init()
        interactorUnderTest.worker = authorsWorkerSpy
        
        // When
        let request = AuthorList.FetchAuthorList.Request(pageNumber: 1, urlToRequest: "sampleURL", sortOrder: .ascending)
        interactorUnderTest.fetchAuthors(request: request)
        
        // Then
        XCTAssert(authorsWorkerSpy.fetchAuthorsCalled, "fetchAuthorsCalled() should ask AuthorWorker to fetch Authors")
        XCTAssert(authorPresentationLogicSpy.presentAuthorListCalled, "FetchAuthors() should ask presenter to show author result")
    }
    
    
    
    
   
 
}
