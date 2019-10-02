

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
    
    class PostListDisplayLogicSpy: AuthorPostDetailsDisplayLogic
    {
        
        var presentAuthorCalled = false
        var presentPostListCalled = false
        var errorCallBackForPostListCalled = false

        var viewModelAuthor: AuthorPostDetails.FetchAuthorDetails.ViewModel!
        var viewModelPost: AuthorPostDetails.FetchPostDetails.ViewModel!
        
        func displayAuthorDetails(viewModel: AuthorPostDetails.FetchAuthorDetails.ViewModel) {
            
            presentAuthorCalled = true
            self.viewModelAuthor = viewModel
            
        }
        
        func displayPostDetails(viewModel: AuthorPostDetails.FetchPostDetails.ViewModel) {
            presentPostListCalled = true
            self.viewModelPost = viewModel
        }
        
        func errorReceivedInPostFetchRequest(error: MBError) {
            
            errorCallBackForPostListCalled = true
        }
        
    }
    
    // MARK: - Tests
    
    func testPresentDisplayedAuthorShouldFormatFetchedAuthorDisplay()
    {
        // Given
        let authorDisplayLogicSpy = PostListDisplayLogicSpy()
        presenterUnderTest.viewController = authorDisplayLogicSpy
        
        let firstAuthor = Seeds.Authors.firstAuthor
        
        
        let response = AuthorPostDetails.FetchAuthorDetails.Response(author: firstAuthor)
        presenterUnderTest.presentAuthor(response: response)
        
        // Then
        let displayedAuthor = authorDisplayLogicSpy.viewModelAuthor.authorDetails
        
        XCTAssertEqual(displayedAuthor.id, "1", "Presenting fetched authors should properly format author ID")
        XCTAssertEqual(displayedAuthor.name, "authorFirst", "Presenting fetched authors should properly format author name")
        XCTAssertEqual(displayedAuthor.email, "author.first@email.id", "Presenting fetched authors should properly format email")
        
    }
    
    func testPresentDisplayedPostShouldFormatFetchedPostDisplay()
    {
        // Given
        let authorListDisplayLogicSpy = PostListDisplayLogicSpy()
        presenterUnderTest.viewController = authorListDisplayLogicSpy
        
        let post = Seeds.Posts.firstPost
        
        let response = AuthorPostDetails.FetchPostDetails.Response(postList: [post], error: nil)
        presenterUnderTest.presentPostList(response: response)
        
        // Then
        let displayedPost = authorListDisplayLogicSpy.viewModelPost.postList
        
        for displayedEachPost in displayedPost
        {
            XCTAssertEqual(displayedEachPost.body, post.body, "Presenting fetched post should properly format post body")
            XCTAssertEqual(displayedEachPost.title, post.title, "Presenting fetched post should properly format author title")
            XCTAssertEqual(displayedEachPost.date, "Dec 5, 2017", "Presenting fetched post should properly format date")
            
        }
        
    }
    
    
    func testPresentFetchedAuthorsShouldAskViewControllerToDisplayFetchedAuthor()
    {
        // Given
        let postListDisplayLogicSpy = PostListDisplayLogicSpy()
        presenterUnderTest.viewController = postListDisplayLogicSpy
        
        // When
        let author = Seeds.Authors.firstAuthor
        let response = AuthorPostDetails.FetchAuthorDetails.Response(author: author)
        presenterUnderTest.presentAuthor(response: response)
        
        // Then
        XCTAssertTrue(postListDisplayLogicSpy.presentAuthorCalled, "Presenting fetched authors should ask view controller to display them")
    }
    
    func testPresentFetchedPostlistShouldAskViewControllerToDisplayFetchedPostlist()
    {
        // Given
        let postListDisplayLogicSpy = PostListDisplayLogicSpy()
        presenterUnderTest.viewController = postListDisplayLogicSpy
        
        // When
        let post = Seeds.Posts.firstPost
        let response = AuthorPostDetails.FetchPostDetails.Response(postList: [post], error: nil)
        presenterUnderTest.presentPostList(response: response)
        
        // Then
        XCTAssertTrue(postListDisplayLogicSpy.presentPostListCalled, "Presenting fetched post should ask view controller to display them")
    }
    
    func testPresentFaultyFetchedPostlistShouldAskViewControllerToDisplayError()
    {
        // Given
        let postListDisplayLogicSpy = PostListDisplayLogicSpy()
        presenterUnderTest.viewController = postListDisplayLogicSpy
        
        // When
        let testError = MBError.init(mbErrorCode: .GeneralError)

        let response = AuthorPostDetails.FetchPostDetails.Response(postList: nil, error: testError)
        presenterUnderTest.presentPostList(response: response)
        
        // Then
        XCTAssertTrue(postListDisplayLogicSpy.errorCallBackForPostListCalled, "Presenting fetched post should ask view controller to display error")
    }
    
    
}
