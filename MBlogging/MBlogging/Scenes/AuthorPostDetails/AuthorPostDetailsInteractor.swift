//
//  AuthorPostDetailsInteractor.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 28/09/2019.
//  Copyright (c) 2019 Sujata Chakraborty. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AuthorPostDetailsBusinessLogic
{
    /**
     Use this function to get author details
     */
    
    func getAuthorDetails(request: AuthorPostDetails.FetchAuthorDetails.Request)
    
    /**
     Use this function to get author details of sepecific author ,author id will be used
     */
    
    func fetchPostDetails(request: AuthorPostDetails.FetchPostDetails.Request , order : SortOrder)
    
}

protocol AuthorPostDetailsDataStore
{
    var author: Author! { get set }
    
}

class AuthorPostDetailsInteractor: AuthorPostDetailsBusinessLogic, AuthorPostDetailsDataStore
{
    var author: Author!
    var postForSpecificAuthor : [Post]?
    
    var presenter: AuthorPostDetailsPresentationLogic?
    var worker: AuthorPostDetailsWorker = AuthorPostDetailsWorker()
    
    
    
    // MARK: Responsibility of Interactor
    
    func getAuthorDetails(request: AuthorPostDetails.FetchAuthorDetails.Request)
    {
        let response = AuthorPostDetails.FetchAuthorDetails.Response.init(author: author)
        presenter?.presentAuthor(response: response)
    }
    
    
    func fetchPostDetails(request: AuthorPostDetails.FetchPostDetails.Request , order : SortOrder)
    {
        guard let authorId = request.authorId else
        {
            let mbError = MBError.init(mbErrorCode: MBErrorCode.GeneralError)
            mbError.mbErrorDebugInfo = "Author id is missing for fetching posts"
            
            let response = AuthorPostDetails.FetchPostDetails.Response(postList: nil, error: mbError)
            presenter?.presentPostList(response: response)
            
            return
        }
        
        weak var weakself = self
        
        worker.fetchPostDetails(url: Constants.baseURL, authorID: authorId, order: order) { (postList, error) in
            
            if let postList = postList
            {
                
                weakself?.postForSpecificAuthor = postList
                
                let response = AuthorPostDetails.FetchPostDetails.Response(postList: postList, error: nil)
                weakself?.presenter?.presentPostList(response: response)
                
            }
            else if let  error = error
            {
                let response = AuthorPostDetails.FetchPostDetails.Response(postList: nil, error: error)
                weakself?.presenter?.presentPostList(response: response)
            }
        }
    }
    
}
