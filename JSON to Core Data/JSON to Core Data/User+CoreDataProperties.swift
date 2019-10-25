//
//  User+CoreDataProperties.swift
//  JSON to Core Data
//
//  Created by 이성민 on 10/14/19.
//  Copyright © 2019 KSAD. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String
    @NSManaged public var age: Int16
    @NSManaged public var id: Int16

}
