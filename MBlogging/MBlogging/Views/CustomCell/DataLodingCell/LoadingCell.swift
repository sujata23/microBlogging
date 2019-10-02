//
//  LoadingCell.swift
//  MBlogging
//
//  Created by Sujata Chakraborty on 02/20/2019.
//  Copyright (c) 2019 Sujata Chakraborty. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
