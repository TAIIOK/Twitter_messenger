//
//  Friends.swift
//  TwitterLab
//
//  Created by Roman Efimov on 19.12.15.
//  Copyright © 2015 Roman Efimov. All rights reserved.
//



import UIKit
class Friends {
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var id: String
    
    // MARK: Initialization
    
    init?(name: String,photo: UIImage!,id: String) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.id = id

        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty  {
            return nil
        }
    }
}
