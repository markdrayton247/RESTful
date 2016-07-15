//
//  TableViewCell.swift
//  RESTful
//
//  Created by Mark Drayton on 14/07/2016.
//  Copyright © 2016 Mark Drayton Ltd. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
