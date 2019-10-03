//
//  AuthotListCell.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 27/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class AuthorListCell : UITableViewCell
{
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorEmailId: UILabel!
    @IBOutlet weak var authorImageView: CustomImageView!
    
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
    func initWith(authorDetails:AuthorList.FetchAuthorList.ViewModel.DisplayAuthorList){
        
        commonSetUp()
        authorName.text = authorDetails.name
        authorEmailId.text = authorDetails.email
        authorImageView.setFallbackImageForRequest(fallBack:UIImage.init(named: "fallback-packshot") ?? UIImage())
        authorImageView.setHighResImageURL(highResImageURL: authorDetails.avatarUrl, title: "", handler: nil)
        
    }
    
    
    /**
     Function where every data showing in cell will be reset
     */
    func cleanData()
    {
        authorName.text = ""
        authorEmailId.text = ""
        authorImageView.setHighResImageURL(highResImageURL: "", title: nil, handler: nil)
        
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
        return CGFloat(Constants.kDefaultCellHeight)
    }
}
