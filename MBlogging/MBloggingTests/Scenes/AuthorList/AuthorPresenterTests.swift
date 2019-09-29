

@testable import MBlogging
import XCTest

class AuthorPresenterTests: XCTestCase
{
  // MARK: - Subject under test
  var presenterUnderTest : AuthorListPresenter!
  
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupAuthorPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupAuthorPresenter()
  {
    presenterUnderTest = AuthorListPresenter()
  }
  
  // MARK: - Test doubles
  
  class AuthorListDisplayLogicSpy: AuthorListDisplayLogic
  {
    
    // MARK: Method call expectations
    
    var displayFetchedAuthorsCalled = false
    
    // MARK: Argument expectations
    
    var viewModel: AuthorList.FetchAuthorList.ViewModel!
    
    // MARK: Spied methods
    
    func displayAuthorList(viewModel: AuthorList.FetchAuthorList.ViewModel) {
        
        displayFetchedAuthorsCalled = true
        self.viewModel = viewModel
    }
    
    func errorReceivedInAuthorFetchRequest(error: MBError) {
        displayFetchedAuthorsCalled = true
    }
  }
  
  // MARK: - Tests
  
  func testPresentFetchedAuthorListShouldFormatFetchedAuthorForDisplay()
  {
    // Given
    let authorListDisplayLogicSpy = AuthorListDisplayLogicSpy()
    presenterUnderTest.viewController = authorListDisplayLogicSpy
    
    let firstAuthor = Seeds.Authors.firstAuthor
    
    
    let response = AuthorList.FetchAuthorList.Response(authors: [firstAuthor], error: nil)
    presenterUnderTest.presentAuthorList(response: response)
    
    // Then
    let displayedAuthorList = authorListDisplayLogicSpy.viewModel.authorList
    for displayedAuthor in displayedAuthorList {
      XCTAssertEqual(displayedAuthor.id, "1", "Presenting fetched orders should properly format author ID")
      XCTAssertEqual(displayedAuthor.name, "authorFirst", "Presenting fetched orders should properly format author name")
      XCTAssertEqual(displayedAuthor.email, "author.first@email.id", "Presenting fetched authors should properly format email")
      XCTAssertEqual(displayedAuthor.userName, "authorFirstUN", "Presenting fetched author should properly format username")
      XCTAssertEqual(displayedAuthor.avatarUrl, "firstuserURL", "Presenting fetched author should properly format url")
    }
  }

  func testPresentFetchedAuthorsShouldAskViewControllerToDisplayFetchedOrders()
  {
    // Given
    let authorListDisplayLogicSpy = AuthorListDisplayLogicSpy()
    presenterUnderTest.viewController = authorListDisplayLogicSpy

    // When
    let authors = [Seeds.Authors.firstAuthor]
    let response = AuthorList.FetchAuthorList.Response(authors: authors, error: nil)
    presenterUnderTest.presentAuthorList(response: response)

    // Then
    XCTAssert(authorListDisplayLogicSpy.displayFetchedAuthorsCalled, "Presenting fetched authors should ask view controller to display them")
  }
}
