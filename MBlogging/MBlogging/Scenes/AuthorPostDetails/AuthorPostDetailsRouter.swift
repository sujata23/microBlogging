//
//  AuthorPostDetailsRouter.swift
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

@objc protocol AuthorPostDetailsRoutingLogic
{
    func routeToCommentListPage()
}

protocol AuthorPostDetailsDataPassing
{
    var dataStore: AuthorPostDetailsDataStore? { get }
}

class AuthorPostDetailsRouter: NSObject, AuthorPostDetailsRoutingLogic, AuthorPostDetailsDataPassing
{
    weak var viewController: AuthorPostDetailsViewController?
    var dataStore: AuthorPostDetailsDataStore?
    
    
    func routeToCommentListPage()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "CommentSectionViewController") as! CommentSectionViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToAuthorDetails(source: dataStore!, destination: &destinationDS)
        navigateToAuthorDetails(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToAuthorDetails(source: AuthorPostDetailsViewController, destination: CommentSectionViewController)
    {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToAuthorDetails(source: AuthorPostDetailsDataStore, destination: inout CommentSectionDataStore)
    {
        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
        destination.referencePost = source.postList?[selectedRow!]
    }
    
}
