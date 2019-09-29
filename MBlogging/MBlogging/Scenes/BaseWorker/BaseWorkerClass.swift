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
}
