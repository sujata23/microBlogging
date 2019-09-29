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
        static let stringDateInput = "2017-09-21T18:52:15.696Z"
        static let date = "stringwithBlankAtStartAndBack"
        static let modifiedDate = "Sep 21, 2017"
        
    }
}
