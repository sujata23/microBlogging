@testable import MBlogging
import XCTest

struct Seeds
{
    struct Authors
    {
        
        static let firstAuthor = Author(id: 1, name: "authorFirst", userName: "authorFirstUN", email: "author.first@email.id", avatarUrl: "firstuserURL")
        static let secondAuthor = Author(id: 2, name: "authorSecond", userName: "authorSecondUN", email: "author.second@email.id", avatarUrl: "seconduserURL")
        
    }
    
    struct Posts
    {
        
        static let firstPost = Post(id: 1, date: "2017-12-05T02:18:18.571Z", title: "POST TITLE 1", body: "POST BODY 1")
        static let secondPost = Post(id: 2, date: "2017-01-06T02:19:19.571Z", title: "POST TITLE 2", body: "POST BODY 2")
        
    }
    
    
    struct StringTest
    {
        static let stringWithSpaces = "   stringwithBlankAtStartAndBack   "
        static let stringWithOutSpaces = "stringwithBlankAtStartAndBack"
        
    }
    
    struct UtilityTest
    {
        static let stringDateInput = "2017-12-05T18:52:15.696Z"
        static let date = "stringwithBlankAtStartAndBack"
        static let modifiedDate = "Dec 5, 2017"
        
    }
    
    struct Order
    {
        static let ascOrderQueryStr = "_sort=date&_order=asc"
        static let descOrderQueryStr = "_sort=date&_order=desc"
        
    }
    
    struct Comments
    {
        
        static let firstComment = Comment.init(id: 1, date: "2017-12-05T02:18:18.571Z", userName: "commenter1", body: "test comment1", avatarUrl: "avater URL", postId: 1, email: "emailid@test.com")
        static let secondComment = Comment.init(id: 2, date: "2017-12-06T02:18:18.571Z", userName: "commenter2", body: "test comment2", avatarUrl: "avater URL2", postId: 2, email: "emailid2@test.com")
        
    }
}
