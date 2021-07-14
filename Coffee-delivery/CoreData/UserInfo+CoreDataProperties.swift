//
//  UserInfo+CoreDataProperties.swift
//  Coffee-delivery
//
//  Created by User on 14/07/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var cart: NSObject?
    @NSManaged public var history: NSObject?

}
