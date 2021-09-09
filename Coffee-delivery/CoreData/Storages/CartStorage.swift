//
//  CartStorage.swift
//  Coffee-delivery
//
//  Created by User on 23/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import CoreData

class CartStorage {
    
    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func update( _ cafeId: Int, _ id: Int, _ quantity: Int) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cart")
        
        do {
            
            let managedObjects = try context.fetch(fetchRequest)
            
            for obj in managedObjects {
                
                if cafeId == (obj.value(forKey: "cafeId") as? Int)! && id == (obj.value(forKey: "id") as? Int)! {
                    
                    obj.setValue(quantity, forKey: "count")
                    
                    saveContext()
                }
                
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(products : [Product], for cafeId: Int) {
        
        for product in products {
            
            let entity = NSEntityDescription.entity(forEntityName: "Cart", in: context)!
            let cart = NSManagedObject(entity: entity, insertInto: context)
            
            cart.setValue(product.title, forKeyPath: "title")
            cart.setValue(product.price, forKeyPath: "price")
            cart.setValue(product.inCart(), forKeyPath: "count")
            cart.setValue(product.id, forKeyPath: "id")
            cart.setValue(cafeId, forKeyPath: "cafeId")
            
            saveContext()
            
        }
        
    }
    
    
    // returns [index : count]
    
    func content(for cafeId: Int) -> [Int : Int]? {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cart")
        
        do {
            
            let managedObjects = try context.fetch(fetchRequest)
            
            if managedObjects.count != 0 {
                
                var quantities : [Int : Int] = [:]
                
                for i in managedObjects {
                    
                    if cafeId == (i.value(forKey: "cafeId") as? Int)! {
                        
                        let _id = (i.value(forKey: "id") as? Int)!
                        let quantity = (i.value(forKey: "count") as? Int)!
                        
                        quantities[_id] = quantity
                        
                    }
                    
                }
                
                return quantities
            } else { return nil }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    func remove(product : NSManagedObject) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            for obj in try context.fetch(fetchRequest) as! [NSManagedObject] {
                if product == obj {
                    context.delete(obj)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        saveContext()
    }
    
    func removeAll() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            for obj in try context.fetch(fetchRequest) as! [NSManagedObject] {
                context.delete(obj)
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        saveContext()
        
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
