//
//  AuthotListCell.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 28/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class PostDetailsCell : UITableViewCell
{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var postBody: UILabel!

    //MARK : UI Modification
    
    func commonSetUp()
    {
    }
    
    
    
    //MARK: INIT Function
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /**
     This init function will be called with Displayed author object.
     Using the object we need to populate the value in UI Fields
     */
    func initWith(postDetail : AuthorPostDetails.FetchPostDetails.ViewModel.DisplayedPost){
        
        commonSetUp()
        title.text = postDetail.title
        date.text = postDetail.date
        postBody.text = postDetail.body

    }
    
    
    /**
     Function where every data showing in cell will be reset
     */
    func cleanData()
    {
        title.text = ""
        date.text = ""
        postBody.text = ""

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanData()
    }
    
    /**
     This Function can be used to get cell height required
     Currenly it is a static value. If required we can dyanamically calculate UIelement height and set Dynamic height
     */
    
    class func retreiveCellHeight() -> CGFloat
    {
        return 100.0
    }
}
