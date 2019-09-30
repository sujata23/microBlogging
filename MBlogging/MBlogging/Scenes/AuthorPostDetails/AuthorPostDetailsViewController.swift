//
//  AuthorPostDetailsViewController.swift
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

protocol AuthorPostDetailsDisplayLogic: class
{
    /**
     callback from presenter to show author details in header view
     We show the data from ViewModel
     */
    
    func displayAuthorDetails(viewModel: AuthorPostDetails.FetchAuthorDetails.ViewModel)
    
    /**
     callback from presenter to show post list posted by the author mentioned in Header View
     We show the data from ViewModel
     */
    
    func displayPostDetails(viewModel: AuthorPostDetails.FetchPostDetails.ViewModel)
    
    /**
     callback from presenter about error it received while fetching post list
     In this function we can show the error to user , if required
     */
    
    func errorReceivedInAuthorFetchRequest(error : MBError)
    
    
}

class AuthorPostDetailsViewController: UITableViewController, AuthorPostDetailsDisplayLogic
{
    
    //Constant
    
    static let cellIdentifier =  "PostDetailsCell"
    static let headerIdentifier =  "CustomTableViewHeader"
    
    static let headerHeight =  100
    
    
    var interactor: AuthorPostDetailsBusinessLogic?
    var router: (NSObjectProtocol & AuthorPostDetailsRoutingLogic & AuthorPostDetailsDataPassing)?
    
    
    var displayedAuthor : AuthorPostDetails.FetchAuthorDetails.ViewModel.DisplayAuthor?
    var displayedPostList : [AuthorPostDetails.FetchPostDetails.ViewModel.DisplayedPost] = []
    
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpUI()
        
        showAuthorDetails()
    }
    
    
    // MARK: Setup
    
    /**
     Call this function to set up items to maintain clean architecture.
     */
    
    private func setup()
    {
        let viewController = self
        let interactor = AuthorPostDetailsInteractor()
        let presenter = AuthorPostDetailsPresenter()
        let router = AuthorPostDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    // MARK: Routing to different Controller
    
    func navigateToCommentList()
    {
        if let router = router {
            router.routeToCommentListPage()
        }
        
    }

    
    
    //MARK: Set up View
    
    /**
     Use this function to create or configure views you want to show in author list page
     */
    
    func setUpUI()
    {
        // TableView header creation
        
        let nib = UINib(nibName: "CustomSectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "CustomTableViewHeader")
        
        //Table view cell
        
        let postListTableCell = UINib(nibName: "PostDetailsCell", bundle: nil)
        self.tableView.register(postListTableCell, forCellReuseIdentifier: AuthorPostDetailsViewController.cellIdentifier)
        
        
        //Configure tableview setting
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    
    //MARK: Data Fetch functions
    
    /**
     Call this get author Details
     */
    
    func showAuthorDetails()
    {
        let request = AuthorPostDetails.FetchAuthorDetails.Request()
        interactor?.getAuthorDetails(request: request)
    }
    
    /**
     Call this get Post list for specific author
     */
    
    func showPostList()
    {
        let request = AuthorPostDetails.FetchPostDetails.Request(authorId: displayedAuthor?.id)
        
        // Assuming we are showing post list in ascending date order
        interactor?.fetchPostDetails(request: request, order: .ascending)
    }
    
    
    //MARK: AuthorPostDetailsDisplayLogic functions
    
    func displayAuthorDetails(viewModel: AuthorPostDetails.FetchAuthorDetails.ViewModel)
    {
        displayedAuthor = viewModel.authorDetails
        showPostList()
        self.title = displayedAuthor?.userName
        self.tableView.reloadData()
    }
    
    func displayPostDetails(viewModel: AuthorPostDetails.FetchPostDetails.ViewModel)
    {
        displayedPostList = viewModel.postList
        self.tableView.reloadData()
        
    }
    
    func errorReceivedInAuthorFetchRequest(error: MBError) {
        
        //Currently we are not showing any error
    }
    
    
    
    
    //MARK: UITableView DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> PostDetailsCell {
        
        let displayedPost = displayedPostList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: AuthorPostDetailsViewController.cellIdentifier) as! PostDetailsCell
        cell.initWith(postDetail: displayedPost)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> CustomSectionHeader? {
        
        // Dequeue with the reuse identifier
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier:AuthorPostDetailsViewController.headerIdentifier) as! CustomSectionHeader
        
        if let author = self.displayedAuthor
        {
            header.initWith(authorDetails:author)
        }
        return header
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(AuthorPostDetailsViewController.headerHeight)
    }
    
    
    // We have only one section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedPostList.count
    }
    
    
    //MARK: UITableView delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigateToCommentList()
    }

    
    
}
