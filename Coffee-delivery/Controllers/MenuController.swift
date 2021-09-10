//
//  MenuController.swift
//  Coffee-delivery
//
//  Created by User on 09/07/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit


protocol ProductDelegate {
    func addProductToCart(productId : Int)
}


class MenuController: UIViewController {
    
    private let parser = CoffeeParser()
    private var cartStorage = CartStorage()
    
    private var goods : [Int : Product] = [:] // index : product
    var cart : [Int : Product] = [:]
    var menuID : String!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var searchItem: UIBarButtonItem!
    
    // constraints
    @IBOutlet weak var orderBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderBtnViewHeightConstraint: NSLayoutConstraint!
    
    private let collectionLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderBtn.layer.cornerRadius = 10
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = collectionLayout
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        orderBtnBottomConstraint.constant = -orderBtnViewHeightConstraint.constant
        
        parser.fetchGoods(menuID: menuID, { goods in
            self.goods = goods
            self.initCart()
            self.collectionView.reloadData()
        })
    }
    
    private func initCart() {
        if let quantities = cartStorage.content(for: Int(menuID)!) {
            if quantities.count == 0 {
                
                let alert = UIAlertController(title: "Очистить корзину?", message: "В вашей корзине находятся товары из другой кофейни, поэтому её необходимо очистить.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Назад", style: .cancel, handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { (_) in
                    self.cartStorage.removeAll()
                }))

                self.present(alert, animated: true)
                
            } else {
                showOrderBtn()
                quantities.forEach { (key, value) in
                    cart[key] = goods[key]
                    cart[key]?.add(value)
                }
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            CartController {
            
            for (_, product) in cart {
                destination.cart.append(product)
            }
            
        } else if let destination = segue.destination as? DrinkDetailsController, let item = collectionView.indexPathsForSelectedItems?.last?.row {
            destination.product = goods[item]!
            destination.delegate = self
        } else if let destination = segue.destination as? SearchProductsController {
            destination.searchGoods = [Product](goods.values)
            destination.detailDelegate = self
        }
    }
}


extension MenuController: ProductDelegate {
    
    func addProductToCart(productId: Int) {
        self.addToCart(productId)
        self.collectionView.reloadItems(at: [IndexPath(item: productId, section: 0)])
    }
    
    
}


extension MenuController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.ID, for: indexPath) as! ProductCell
        
        if cart.keys.contains(indexPath.row) {
            cell.countLabel.text = String(self.cart[indexPath.row]!.inCart())
            cell.initData(product: cart[indexPath.row]!)
        } else {
            cell.initData(product: goods[indexPath.row]!)
        }
        
        loadImageIfNeeded(array: goods, item: indexPath.row, cell: cell)
        
        // actions
        
        cell.addProductAction = { self.addToCart(indexPath.row) }
        cell.increaseCountAction = { self.addToCart(indexPath.row) }
        cell.decreaseCountAction = { self.subtractFromCart(indexPath.row, cell) }
    
        return cell
    }
    
    private func loadImageIfNeeded(array: [Int : Product], item: Int, cell: ProductCell) {
        if let img = array[item]!.image {
            cell.productImageView.image = img
        } else {
            parser.getImage(array[item]!.imageURL!) { (img) in
                array[item]!.image = img
                self.collectionView.reloadItems(at: [IndexPath(item: item, section: 0)])
            }
        }
    }

    
    private func addToCart( _ productId : Int) {
        
        if self.cart.keys.contains(productId) {
            self.cart[productId]!.add()
            cartStorage.update(Int(menuID)!, productId, self.cart[productId]!.inCart())
            collectionView.reloadItems(at: [IndexPath(row: productId, section: 0)])
        } else {
            if cart.count == 0 { showOrderBtn() }
            cart[productId] = goods[productId]!
            cart[productId]?.add()
        }
        
        cartStorage.removeAll()
        cartStorage.save(products: [Product](self.cart.values), for: Int(menuID)!)
        
    }
    
    private func subtractFromCart( _ productId : Int, _ cell: ProductCell) {
        if self.cart.keys.contains(productId) {
            self.cart[productId]!.subtract()
            collectionView.reloadItems(at: [IndexPath(row: productId, section: 0)])
        }
        
        if self.cart[productId]!.removeFromCart {
            cell.btnsMapping(self.cart[productId]!.inCart())
            self.cart.removeValue(forKey: productId)
            if cart.count == 0 { hideOrderBtn() }
        }
        
        cartStorage.removeAll()
        cartStorage.save(products: [Product](self.cart.values), for: Int(menuID)!)
    }
    
    private func showOrderBtn() {
        
        orderBtnBottomConstraint.constant = 0
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: orderBtnViewHeightConstraint.constant, right: 20)
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideOrderBtn() {
        
        orderBtnBottomConstraint.constant = -orderBtnViewHeightConstraint.constant
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            UIView.animate(withDuration: 0.3) {
                self.collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
