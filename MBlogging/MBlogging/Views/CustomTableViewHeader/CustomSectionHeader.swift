//
//  CustomTableViewHeader.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 27/09/2019.
//  Copyright © 2019 Sujata Chakraborty. All rights reserved.
//

import Foundation
import UIKit

class CustomSectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorEmailId: UILabel!
    @IBOutlet weak var authorImage: CustomImageView!

   
    func initWith(authorDetails: AuthorPostDetails.FetchAuthorDetails.ViewModel.DisplayAuthor){
       
        let displayedAuthor = authorDetails
        authorName.text = displayedAuthor.name
        authorEmailId.text = displayedAuthor.email
        authorImage.setFallbackImageForRequest(fallBack:UIImage.init(named: "fallback-packshot") ?? UIImage())
        authorImage.setHighResImageURL(highResImageURL: displayedAuthor.avatarUrl, title: "", handler: nil)
    }
    
}
