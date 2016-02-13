//
//  ChatViewCell.swift
//  TwitterLab
//
//  Created by Roman Efimov on 19.12.15.
//  Copyright © 2015 Roman Efimov. All rights reserved.
//


import Foundation
import UIKit

class ChatViewCell: UITableViewCell {

    @IBOutlet weak var friendimage: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var myimage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
