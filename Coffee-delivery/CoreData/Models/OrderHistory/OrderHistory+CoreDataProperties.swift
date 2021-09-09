//
//  OrderHistory+CoreDataProperties.swift
//  Coffee-delivery
//
//  Created by User on 07/09/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderHistory> {
        return NSFetchRequest<OrderHistory>(entityName: "OrderHistory")
    }

    @NSManaged public var cafeTitle: String?
    @NSManaged public var deliveryDate: Date?
    @NSManaged public var totalPrice: String?

}
