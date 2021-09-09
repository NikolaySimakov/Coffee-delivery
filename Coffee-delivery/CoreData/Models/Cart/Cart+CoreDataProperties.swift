//
//  Cart+CoreDataProperties.swift
//  Coffee-delivery
//
//  Created by User on 07/09/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }

    @NSManaged public var cafeId: Int16
    @NSManaged public var count: Int16
    @NSManaged public var id: Int16
    @NSManaged public var price: String?
    @NSManaged public var title: String?

}
