//
//  Chat.swift
//  TwitterLab
//
//  Created by Roman Efimov on 19.12.15.
//  Copyright © 2015 Roman Efimov. All rights reserved.
//

import Foundation
import UIKit

class Chat {
    // MARK: Properties
    
    var message: String
    var photoin: UIImage?
    var photoout: UIImage?
    // MARK: Initialization
    
    init?(name: String,photoin: UIImage!,photoout: UIImage!) {
        // Initialize stored properties.
        self.message = name
        self.photoin = photoin
        self.photoout = photoout
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty  {
            return nil
        }
    }
}