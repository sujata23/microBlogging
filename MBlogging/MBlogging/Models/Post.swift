//
//  Author.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 28/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

import Foundation


struct Post : Decodable
{
    var id: Int
    var date: String
    var title: String
    var body: String
}
