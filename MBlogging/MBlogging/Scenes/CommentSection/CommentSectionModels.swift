//
//  CommentSectionModels.swift
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

enum CommentSection
{
    // MARK: Use cases
    
    enum FetchCommentList
    {
        struct Request
        {
            var postId: String?
        }
        struct Response
        {
            var commentList: [Comment]?
            var error:    MBError?
        }
        struct ViewModel
        {
            
            struct DisplayedComment
            {
                var userName: String
                var date:  String
                var body:  String
                var avatarUrl : String
            }
            
            var commentList: [DisplayedComment]
            
            
        }
    }
    
    enum FetchReferencePost
    {
        struct Request
        {
        }
        struct Response
        {
            var post : Post
        }
        struct ViewModel
        {
            struct DisplayPost
            {
                var id:        String
            }
            var postInfo : DisplayPost
            
        }
    }
}
