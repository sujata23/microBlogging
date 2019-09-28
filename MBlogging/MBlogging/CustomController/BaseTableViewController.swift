//
//  BaseTableViewController.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 28/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

import Foundation
import UIKit

/**
  Creating UITableViewController
 */

class BaseTableViewController : UITableViewController
{
    //Check whether author fetch request is already ongoing or not
    var isOngoingRequest = false
    var isPaginationRequired = false

    
    // MARK: - ScrollView Delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard isPaginationRequired == true else
        {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        
        if offsetY > contentHeight - scrollView.frame.height * 4 {
            if !isOngoingRequest {
                fetchNextBatchRequest()
            }
            
        }
    }
    
    //MARK: Fetch next set of request
    
    func fetchNextBatchRequest()
    {
       
    }
    
    
}
