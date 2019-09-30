//
//  AuthorPostDetailsPresenter.swift
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

protocol AuthorPostDetailsPresentationLogic
{
    /**
     Use this function modify author response and modify nd create viewmodel to display
     */
    
    func presentAuthor(response:  AuthorPostDetails.FetchAuthorDetails.Response)
    
    /**
     Use this function modify post list response and modify nd create viewmodel to display
     */
    
    func presentPostList(response: AuthorPostDetails.FetchPostDetails.Response)
}

class AuthorPostDetailsPresenter: BasePresenterClass, AuthorPostDetailsPresentationLogic
{
    weak var viewController: AuthorPostDetailsDisplayLogic?
    var displayedPostList: [AuthorPostDetails.FetchPostDetails.ViewModel.DisplayedPost] = []
    
    
    
    // MARK: AuthorPostDetailsPresentationLogic functions
    
    func presentAuthor(response:  AuthorPostDetails.FetchAuthorDetails.Response)
    {
        let author = response.author
        let displayedAuthor = AuthorPostDetails.FetchAuthorDetails.ViewModel.DisplayAuthor(id: String(author.id), name: author.name , userName : author.userName , email : author.email , avatarUrl : author.avatarUrl)
        let viewModel = AuthorPostDetails.FetchAuthorDetails.ViewModel.init(authorDetails: displayedAuthor)
        self.viewController?.displayAuthorDetails(viewModel: viewModel)
        
    }
    
    func presentPostList(response: AuthorPostDetails.FetchPostDetails.Response)
    {
        if let postList = response.postList
        {
            for post in postList {
                
                let dateToShow = dateModificationForPost(sourceDate: post.date)
                let displayedPost = AuthorPostDetails.FetchPostDetails.ViewModel.DisplayedPost(title: post.title, date: dateToShow, body: post.body)
                
                displayedPostList.append(displayedPost)
            }
            
            let viewModel = AuthorPostDetails.FetchPostDetails.ViewModel.init(postList: displayedPostList)
            viewController?.displayPostDetails(viewModel: viewModel)
        }
        else if let error = response.error
        {
            viewController?.errorReceivedInAuthorFetchRequest(error: error)
            
        }
        else
        {
            //Generic error
            let mbError = MBError.init(mbErrorCode: MBErrorCode.ServerError)
            mbError.mbErrorDebugInfo = "Generic error while fetching Post"
            viewController?.errorReceivedInAuthorFetchRequest(error: mbError)
            
        }
        
    }
    
    
}
