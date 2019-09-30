//
//  Author.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 29/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

import Foundation


struct Comment : Decodable
{
    var id: Int
    var date: String
    var userName: String
    var body: String
    var avatarUrl: String
    var postId: Int
    var email: String

}
