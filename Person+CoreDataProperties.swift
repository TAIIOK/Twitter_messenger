//
//  Person+CoreDataProperties.swift
//  TwitterLab
//
//  Created by Roman Efimov on 19.12.15.
//  Copyright © 2015 Roman Efimov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var userID: String?
    @NSManaged var name: String?

}
