//
//  CustomCell.swift
//  CyberNetwork Solutions
//
//  Created by Wang Xiaoming on 4/10/16.
//  Copyright © 2016 Sabilopers. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var tmobilecell: UILabel!
    @IBOutlet var atntcell: UILabel!
    @IBOutlet var sprintcell: UILabel!
    @IBOutlet var verizoncell: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
