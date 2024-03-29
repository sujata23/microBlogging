//
//  AuthorListViewController.swift
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

protocol AuthorListDisplayLogic: class
{
    /**
     callback from presenter to show Authors list in View
     We show the data from ViewModel
     */
    func displayAuthorList(viewModel: AuthorList.FetchAuthorList.ViewModel)
    
    /**
     callback from presenter about error it received while fetching authors data
     As we are doing pagination , in case of error We are reducing one count of the current page
     In this function we can show the error to user , if required
     */
    
    func errorReceivedInAuthorFetchRequest(error : MBError)
}


class AuthorListViewController: BaseTableViewController, AuthorListDisplayLogic
{
    
    //Constant
    
    static let cellIdentifier =  "authorListCell"
    static let cellIdentifierLoading =  "LoadingCell"

    //Clean Architectire Variables
    
    var interactor: AuthorListBusinessLogic?
    var router: (NSObjectProtocol & AuthorListRoutingLogic & AuthorListDataPassing)?
    var displayedAuthors : [AuthorList.FetchAuthorList.ViewModel.DisplayAuthorList] = []
    
    //Properties
    
    var pageToBeFetched = Constants.kInitialPageNumberToBeFetched // Maintains page number to be fetched. Value will be incremented with User scrolling
    
    
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
        setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if displayedAuthors.count == 0
        {
            // to avoid loaing authors while coming back from postdetails page
            fetchAuthors()

        }
    }
    
    // MARK: Setup
    
    /**
     Call this function to set up items to maintain clean architecture.
     */
    private func setup()
    {
        let viewController = self
        let interactor = AuthorListInteractor()
        let presenter = AuthorListPresenter()
        let router = AuthorListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    // MARK: Routing to different Controller
    
    func navigateToAuthorDetailsPage()
    {
        if let router = router {
            router.routeToAuthorDetailPage()
        }
        
    }
    
    
    
    //MARK: Set up View
    
    /**
     Use this function to create or configure views you want to show in author list page
     */
    
    func setUpView()
    {
        title = "Authors"
        self.isPaginationRequired = true
        registerTableViewCell()
    }
    
    /**
     Register custom cell for TableView
     */
    
    func registerTableViewCell()
    {
        let authorListCell = UINib(nibName: "AuthorListCell", bundle: nil)
        self.tableView.register(authorListCell, forCellReuseIdentifier: AuthorListViewController.cellIdentifier)
        //Loading cell register
        
        let loadingNib = UINib(nibName: AuthorListViewController.cellIdentifierLoading, bundle: nil)
        self.tableView.register(loadingNib, forCellReuseIdentifier: AuthorListViewController.cellIdentifierLoading)
    }
    
    
    //MARK: Data Fetch functions
    
    /**
     Call this function to get list of Authors.
     */
    func fetchAuthors()
    {   isOngoingRequest = true
        let request = AuthorList.FetchAuthorList.Request(pageNumber: pageToBeFetched, urlToRequest: Constants.kBaseURL , sortOrder: .ascending)
        interactor?.fetchAuthors(request: request)
    }
    
    
    //MARK: AuthorListDisplayLogic functions
    
    func displayAuthorList(viewModel: AuthorList.FetchAuthorList.ViewModel)
    {
        displayedAuthors = viewModel.authorList
        tableView.reloadData()
        self.isOngoingRequest = false
        
    }
    
    func errorReceivedInAuthorFetchRequest(error: MBError) {
        
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
            return displayedAuthors.count
        } else if section == 1 && isOngoingRequest {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            
            let displayedAuthor = displayedAuthors[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: AuthorListViewController.cellIdentifier) as! AuthorListCell
            cell.initWith(authorDetails: displayedAuthor)
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AuthorListViewController.cellIdentifierLoading, for: indexPath) as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AuthorListCell.retreiveCellHeight()
    }
    
    
    //MARK: UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigateToAuthorDetailsPage()
    }
    
    //MARK: Pagination functions
    
    
    /**
     Use this function to implement functionality required when user scroll down in UITableView
     */
    override func fetchNextBatchRequest()
    {
        guard isOngoingRequest == false else
        {
            return
        }
        
        pageToBeFetched =  pageToBeFetched + 1
        fetchAuthors()
    }
    
    
    
}
