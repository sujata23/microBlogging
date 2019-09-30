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

class CommentCell : UITableViewCell
{
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var postBody: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userThumbnail : CustomImageView!

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
    func initWith(comment : CommentSection.FetchCommentList.ViewModel.DisplayedComment){
        
        commonSetUp()
        userName.text = comment.userName
        date.text = comment.date
        postBody.text = comment.body
        userThumbnail.setFallbackImageForRequest(fallBack:UIImage.init(named: "fallback-packshot") ?? UIImage())
        userThumbnail.setHighResImageURL(highResImageURL: comment.avatarUrl, title: "", handler: nil)
        

    }
    
    
    /**
     Function where every data showing in cell will be reset
     */
    func cleanData()
    {
        userName.text = ""
        date.text = ""
        postBody.text = ""
        userName.text = ""
        userThumbnail.setHighResImageURL(highResImageURL: "", title: "", handler: nil)

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
