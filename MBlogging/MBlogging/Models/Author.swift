//
//  Author.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 27/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

import Foundation


struct Author : Decodable
{
    var id: Int
    var name: String
    var userName: String
    var email: String
    var avatarUrl: String
}
