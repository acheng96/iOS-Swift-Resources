//
//  CategoryTableViewCell.swift
//  Eventful API Demo
//
//  Created by Annie Cheng on 1/17/16.
//  Copyright © 2016 OnO. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
    }

    
}
