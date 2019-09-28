//
//  AuthorListRouter.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 26/09/2019.
//  Copyright (c) 2019 Sujata Chakraborty. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol AuthorListRoutingLogic
{
    func routeToAuthorDetailPage()
}

protocol AuthorListDataPassing
{
    var dataStore: AuthorListDataStore? { get }
}

class AuthorListRouter: NSObject, AuthorListRoutingLogic, AuthorListDataPassing
{
    weak var viewController: AuthorListViewController?
    var dataStore: AuthorListDataStore?
    
    // MARK: Routing
    
    func routeToAuthorDetailPage()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "AuthorPostDetailsViewController") as! AuthorPostDetailsViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToAuthorDetails(source: dataStore!, destination: &destinationDS)
        navigateToAuthorDetails(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToAuthorDetails(source: AuthorListViewController, destination: AuthorPostDetailsViewController)
    {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToAuthorDetails(source: AuthorListDataStore, destination: inout AuthorPostDetailsDataStore)
    {
        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
        destination.author = source.authors?[selectedRow!]
    }
}
