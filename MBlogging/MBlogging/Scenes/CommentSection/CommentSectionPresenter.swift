//
//  CommentSectionPresenter.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 29/09/2019.
//  Copyright (c) 2019 Sujata Chakraborty. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CommentSectionPresentationLogic
{
    /**
     Use this function modify reference post object and modify nd create viewmodel to display
     */
    
    func presentPost(response:  CommentSection.FetchReferencePost.Response)
    
    /**
     Use this function modify comment list response and modify nd create viewmodel to display
     */
    
    func presentCommentList(response: CommentSection.FetchCommentList.Response)
}

class CommentSectionPresenter: BasePresenterClass, CommentSectionPresentationLogic
{
    
    weak var viewController: CommentSectionDisplayLogic?
    var displayedComments: [CommentSection.FetchCommentList.ViewModel.DisplayedComment] = []
    
    
    // MARK: Presenter Responsibility
    
    
    func presentPost(response: CommentSection.FetchReferencePost.Response) {
        
        let referencePost = response.post
        
        let displayedPost = CommentSection.FetchReferencePost.ViewModel.DisplayPost.init(id: String(referencePost.id))
        let viewModel = CommentSection.FetchReferencePost.ViewModel.init(postInfo: displayedPost)
        viewController?.displayReferencePost(viewModel: viewModel)
    }
    
    func presentCommentList(response: CommentSection.FetchCommentList.Response)
    {
        if let commentList = response.commentList
        {
            for comment in commentList {
                
                let dateToShow = dateModificationForPost(sourceDate: comment.date)
                let displayedComment = CommentSection.FetchCommentList.ViewModel.DisplayedComment(userName: comment.userName.trim(), date: dateToShow, body: comment.body.trim(), avatarUrl: comment.avatarUrl.trim())
                //AuthorPostDetails.FetchPostDetails.ViewModel.DisplayedPost(title: post.title, date: dateToShow, body: post.body)
                
                displayedComments.append(displayedComment)
            }
            
            let viewModel = CommentSection.FetchCommentList.ViewModel.init(commentList: displayedComments)
            viewController?.displayCommentList(viewModel: viewModel)
        }
        else if let error = response.error
        {
            viewController?.errorReceivedInCommentFetchRequest(error: error)
            
        }
        else
        {
            //Generic error
            let mbError = MBError.init(mbErrorCode: MBErrorCode.ServerError)
            mbError.mbErrorDebugInfo = "Generic error while fetching Post"
            viewController?.errorReceivedInCommentFetchRequest(error: mbError)
            
        }
    }
    
    
    
    
    
}
