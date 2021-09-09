//
//  OrderStorage.swift
//  Coffee-delivery
//
//  Created by User on 23/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import CoreData

class OrderStorage {
    
    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func show() -> [Order]? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "OrderHistory")
        
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
    
    func save(orderData: Order) {
        let entity = NSEntityDescription.entity(forEntityName: "OrderHistory", in: context)!
        let order = NSManagedObject(entity: entity, insertInto: context)
        
        order.setValue(orderData.cafeTitle, forKeyPath: "cafeTitle")
        order.setValue(orderData.totalPrice, forKeyPath: "totalPrice")
        order.setValue(orderData.deliveryDate, forKeyPath: "deliveryDate")
//        order.setValue(orderData.goods, forKeyPath: "goods")
        
        saveContext()
    }
    
    func update() {
        
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
              context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
