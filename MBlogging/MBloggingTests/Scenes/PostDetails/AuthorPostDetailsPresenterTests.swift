

@testable import MBlogging
import XCTest

class AuthorPostDetailsPresenterTests: XCTestCase
{
  // MARK: - Subject under test
  
  var presenterUnderTest : AuthorPostDetailsPresenter!
  
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupPostPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupPostPresenter()
  {
    presenterUnderTest = AuthorPostDetailsPresenter()
  }
  
  // MARK: - Test doubles
  
  class AuthorListDisplayLogicSpy: AuthorPostDetailsDisplayLogic
  {
    
    var presentAuthorCalled = false
    var presentPostListCalled = false
    var viewModel: AuthorPostDetails.FetchAuthorDetails.ViewModel!

    func displayAuthorDetails(viewModel: AuthorPostDetails.FetchAuthorDetails.ViewModel) {
        
        presentAuthorCalled = true
    }
    
    func displayPostDetails(viewModel: AuthorPostDetails.FetchPostDetails.ViewModel) {
        presentPostListCalled = true
    }
    
    func errorReceivedInAuthorFetchRequest(error: MBError) {
        
    }
    
  }
  
  // MARK: - Tests
  
  func testPresentDisplayedAuthorShouldFormatFetchedAuthorForDisplay()
  {
//    // Given
//    let authorListDisplayLogicSpy = AuthorListDisplayLogicSpy()
//    presenterUnderTest.viewController = authorListDisplayLogicSpy
//    
//    let firstAuthor = Seeds.Authors.firstAuthor
//    
//    
//    let response = AuthorPostDetails.FetchAuthorDetails.Response(author: firstAuthor)
//    presenterUnderTest.presentAuthor(response: response)
//    
//    // Then
//    let displayedAuthor = authorListDisplayLogicSpy.viewModel.authorDetails
//    
//    XCTAssertEqual(displayedAuthor.id, "1", "Presenting fetched orders should properly format author ID")
//    XCTAssertEqual(displayedAuthor.name, "authorFirst", "Presenting fetched orders should properly format author name")
//    XCTAssertEqual(displayedAuthor.email, "author.first@email.id", "Presenting fetched authors should properly format email")
    
  }


}
