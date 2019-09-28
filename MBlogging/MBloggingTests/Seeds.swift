@testable import MBlogging
import XCTest

struct Seeds
{
  struct Authors
  {
    
    static let firstAuthor = Author(id: 1, name: "authorFirst", userName: "authorFirstUN", email: "author.first@email.id", avatarUrl: "firstuserURL")
    static let secondAuthor = Author(id: 2, name: "authorSecond", userName: "authorSecondUN", email: "author.second@email.id", avatarUrl: "seconduserURL")

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
