//
//  TableCell.swift
//  TwitterLab
//
//  Created by Roman Efimov on 19.12.15.
//  Copyright © 2015 Roman Efimov. All rights reserved.
//

import Foundation
import UIKit

class TableViewCell: UITableViewCell {
    
   // MARK: Properties 
    
    @IBOutlet weak var uim: UIImageView!
    @IBOutlet weak var zaim: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
