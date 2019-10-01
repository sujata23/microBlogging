//
//  BaseWorkerClass.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 29/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

import Foundation



class BaseWorkerClass
{
    
    static let sessionManager: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30 // seconds
        configuration.timeoutIntervalForResource = 30 // seconds
        return URLSession(configuration: .default)
    }()
    
    func fetchRequestQueryParameterFor(order : SortOrder) -> String
    {
        if order == .ascending
        {
            return "_sort=date&_order=asc"
        }
        else if order == .decending
        {
            return "_sort=date&_order=desc"
        }
        else
        {
            return ""
        }
    }
    
     func createURLStringWith(baseUrl : String , sortOrder : SortOrder , requestForEntity : String , queryString : String? , pageIndexToBeFetched : Int?) -> URL?
    {
        //will be overriden in Subclasses
        return nil
    }
}
