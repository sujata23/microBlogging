//
//  CommentSectionViewController.swift
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

protocol CommentSectionDisplayLogic: class
{
    /**
     callback from presenter to get post id details
     We show the data from ViewModel
     */
    
    func displayReferencePost(viewModel: CommentSection.FetchReferencePost.ViewModel)
    
    /**
     callback from presenter to show post list posted by the author mentioned in Header View
     We show the data from ViewModel
     */
    
    func displayCommentList(viewModel: CommentSection.FetchCommentList.ViewModel)
    
    /**
     callback from presenter about error it received while fetching post list
     In this function we can show the error to user , if required
     */
    
    func errorReceivedInCommentFetchRequest(error : MBError)
}

class CommentSectionViewController: BaseTableViewController, CommentSectionDisplayLogic
{
    
    //Constant
    
    static let cellIdentifier =  "CommentCell"
    
    //Property
    var pageToBeFetched = 1 // Maintains page number to be fetched. Value will be incremented with User scrolling

    
    var interactor: CommentSectionBusinessLogic?
    var router: (NSObjectProtocol & CommentSectionRoutingLogic & CommentSectionDataPassing)?
    
    var referencePost : CommentSection.FetchReferencePost.ViewModel.DisplayPost?

    var displayedComments : [CommentSection.FetchCommentList.ViewModel.DisplayedComment] = []
    
    
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
    
   
    // MARK: Setup
    
    
    /**
     Call this function to set up items to maintain clean architecture.
     */
    
    private func setup()
    {
        let viewController = self
        let interactor = CommentSectionInteractor()
        let presenter = CommentSectionPresenter()
        let router = CommentSectionRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpView()
        fetchPostForDetailing()
    }
    
    
    //MARK: Set up View
    
    /**
     Use this function to create or configure views you want to show in comment list page
     */
    
    func setUpView()
    {
        title = "Comments"
        self.isPaginationRequired = true
        registerTableViewCell()
        
        //Configure tableview setting
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        tableView.allowsSelection = false;
    }
    
    
    func registerTableViewCell()
    {
        let authorListCell = UINib(nibName: "CommentCell", bundle: nil)
        self.tableView.register(authorListCell, forCellReuseIdentifier: CommentSectionViewController.cellIdentifier)
        
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.tableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
    }
    
    //MARK: Data Fetch functions
    
    /**
     Call this get Post Details
     */
    
    func fetchPostForDetailing()
    {
        let request = CommentSection.FetchReferencePost.Request()
        interactor?.getReferencePost(request: request)
    }
    
    
    /**
     Call this get comment Details
     parameter 1:- postId -> String -> will be used to fetch comment specific to that postId
     */
    
    func fetchCommentFor(postId : String)
    {
        isOngoingRequest = true
        let request = CommentSection.FetchCommentList.Request(postId: postId)
        interactor?.fetchCommentDetails(request: request, order: .ascending, pageNumber: pageToBeFetched)
    }
    
    
    
    //MARK: CommentSectionDisplayLogic functions
    
    func displayReferencePost(viewModel: CommentSection.FetchReferencePost.ViewModel) {
        
        isOngoingRequest = false
        referencePost = viewModel.postInfo
        let postId = viewModel.postInfo.id
        
        fetchCommentFor(postId: postId)
    }
    
    func displayCommentList(viewModel: CommentSection.FetchCommentList.ViewModel) {
        
        isOngoingRequest = false
        displayedComments = viewModel.commentList
        tableView.reloadData()
    }
    
    
    func errorReceivedInCommentFetchRequest(error : MBError)
    {
        
        self.isOngoingRequest = false
        
        if  error.errorCode != nil && (error.errorCode)! == .EmptyData
        {
            self.isPaginationRequired = false
            pageToBeFetched = pageToBeFetched - 1
            self.tableView.reloadData()
            
        }
        else
        {
            
            if pageToBeFetched != 1
            {
                pageToBeFetched = pageToBeFetched - 1
            }
            else
            {
                //Depending on whether we need to show any error or not
            }
        }
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        if isPaginationRequired == true
        {
            return 2
            
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return displayedComments.count
        } else if section == 1 && isOngoingRequest {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            
            let displayedComment = displayedComments[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentSectionViewController.cellIdentifier) as! CommentCell
            cell.initWith(comment: displayedComment)
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
    }
    
    
    //MARK: Pagination functions
    
    
    /**
     Use this function to implement functionality required when user scroll down in UITableView
     */
    override func fetchNextBatchRequest()
    {
        guard  let referencePost = referencePost else {
            return
        }
        pageToBeFetched =  pageToBeFetched + 1
        fetchCommentFor(postId: referencePost.id)
    }
    
    
    
}
