@testable import MBlogging
import XCTest

struct Seeds
{
  struct Authors
  {
    
    static let firstAuthor = Author(id: 1, name: "authorFirst", userName: "authorFirstUN", email: "author.first@email.id", avatarUrl: "firstuserURL")
    static let secondAuthor = Author(id: 2, name: "authorSecond", userName: "authorSecondUN", email: "author.second@email.id", avatarUrl: "seconduserURL")

  }
}
