//
//  customCell3.swift
//  CyberNetwork Solutions
//
//  Created by Wang Xiaoming on 8/19/16.
//  Copyright © 2016 Sabilopers. All rights reserved.
//

import UIKit
import Foundation

class CustomCell3: UITableViewCell {
    

    @IBOutlet weak var nameTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnSamplePressed(sender: AnyObject) {
        
    }
    
}