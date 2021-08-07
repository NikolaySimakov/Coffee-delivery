//
//  MenuController.swift
//  Coffee-delivery
//
//  Created by User on 09/07/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import CoreData


private let reuseIdentifier = "productCell"


class MenuController: UIViewController {
    
    private var goods : [Int : Product] = [:] // index : product
    private var cart : [Int : (Product, Int)] = [:] // index : [product, count]
    private var goodsInCart : [Array<Any>] = []
    var menuID : String!
    
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var searchItem: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderBtn.layer.cornerRadius = 10
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let parser = CoffeeParser()
        parser.fetchGoods(menuID: menuID, { goods in
            self.goods = goods
            self.collectionView.reloadData()
        })
        
        initCart()
    }
    
    
    func initCart() {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserInfo")

        
        do {
            for i in try managedContext.fetch(fetchRequest) {
                goodsInCart.append(
                    (i.value(forKey: "currentCart") as? Array<Any>)!
                )
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    private func addProductToCart(index: Int, count: Int) {
      
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
      
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserInfo", in: managedContext)!
        let cart = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let productTitle = goods[index]!.title
        let productPrice = goods[index]!.price
        cart.setValue([productTitle, productPrice, count], forKeyPath: "currentCart")
      
        do {
            try managedContext.save()
            print("Added successfully")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            CartController {
            for data in cart {
                destination.cart.append(data.value)
            }
        } else if let destination = segue.destination as? DetailController {
            if let item = collectionView.indexPathsForSelectedItems?.last?.row {
                let product = goods[item]!
                destination._title = product.title
                destination._image = (collectionView.cellForItem(at: IndexPath(item: item, section: 0)) as! ProductCell).productImageView.image!
            }
        }
    }
}

extension MenuController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCell
        
        
        cell.layer.cornerRadius = 20
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if cart.keys.contains(indexPath.row) {
            cell.countLabel.text = String(self.cart[indexPath.row]!.1)
            cell.initData(product: goods[indexPath.row]!, count: self.cart[indexPath.row]!.1)
        } else {
            cell.initData(product: goods[indexPath.row]!)
        }

//        for g in goodsInCart {
//            if g[0] as! String == goods[indexPath.row].title {
//                cell.priceBtn.setTitle("Добавлено", for: .normal)
//                cart[indexPath.row] = g[2] as? Int
//            }
//        }
        
        cell.addProductAction = {
//            if self.cart.keys.contains(indexPath.row) {
                self.cart[indexPath.row] = (self.goods[indexPath.row]!, 1)
                
//                self.addProductToCart(index: indexPath.row, count: 1)
//            }
            print(self.cart)
        }
        
        cell.increaseCountAction = {
            let product = self.cart[indexPath.row]!.0
            let count = self.cart[indexPath.row]!.1 + 1
            self.cart[indexPath.row] = (product, count)
            collectionView.reloadItems(at: [indexPath])
        }
        
        cell.decreaseCountAction = {
            if self.cart.keys.contains(indexPath.row) {
                let product = self.cart[indexPath.row]!.0
                let count = max(self.cart[indexPath.row]!.1 - 1, 0)
                self.cart[indexPath.row] = (product, count)
                collectionView.reloadItems(at: [indexPath])
            }
            
            if self.cart[indexPath.row]!.1 == 0 {
                let count = self.cart[indexPath.row]!.1
                cell.btnsMapping(count)
                self.cart.removeValue(forKey: indexPath.row)
            }
        }
    
        return cell
    }

}


extension MenuController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
