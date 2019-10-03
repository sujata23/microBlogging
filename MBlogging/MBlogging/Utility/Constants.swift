//
//  Common.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 26/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

import Foundation

/**
 This order will be used to control the order of the response we want.
 Currently will be used by post list and comment list
 
 */
enum SortOrder :String{
    case ascending
    case decending
}

class Constants
{
    
    static let kBaseURL =  "https://sym-json-server.herokuapp.com/"
    static let kAuthorURLParameter =  "authors"
    static let kPostURLParameter =  "posts"
    static let kCommentsURLParameter =  "comments"
    static let kInitialPageNumberToBeFetched =  1
    static let kDefaultCellHeight =  100
    static let kServerSuccessResponseCode =  200

    
    
}


