//
//  OrdersStorage.swift
//  Coffee-delivery
//
//  Created by User on 23/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import CoreData

class OrdersStorage {
    
    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func show() -> [Order]? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cart")
        
        do {
            
            var orders : [Order] = []
            
            let managedObjects = try context.fetch(fetchRequest)
            
            for obj in managedObjects {
                    
                let cafeTitle = (obj.value(forKey: "cafeTitle") as? String)!
                let totalPrice = (obj.value(forKey: "totalPrice") as? String)!
                let deliveryDate = obj.value(forKey: "deliveryDate") as? Date
                
                orders.append(
                    Order(cafeTitle: cafeTitle, totalPrice: totalPrice, deliveryDate: deliveryDate, goods: [])
                )
            }
                
            return orders
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    func save(order: Order) {
        let entity = NSEntityDescription.entity(forEntityName: "OrderHistory", in: context)!
        let obj = NSManagedObject(entity: entity, insertInto: context)
        
        obj.setValue(order.cafeTitle, forKeyPath: "cafeTitle")
        obj.setValue(order.totalPrice, forKeyPath: "totalPrice")
        obj.setValue(order.deliveryDate, forKeyPath: "deliveryDate")
//        obj.setValue([], forKeyPath: "goods")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func update() {
        
    }
}
