//
//  CartViewController.swift
//  Coffee-delivery
//
//  Created by User on 16/06/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

class CartController: UIViewController {
    
    var deliveryCost : String = "199" // temporary shipping cost
    
    var cart : [Product] = [] {
        didSet {
            if cart.count == 0 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    var cartStorage = CartStorage()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    
    @IBAction func removeGoods(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Очистить корзину?", message: "Это действие нельзя будет отменить.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { _ in
            
            self.cart = []
            self.updateTotalCost()
            self.tableView.reloadData()
            self.cartStorage.removeAll()
            
        }))

        self.present(alert, animated: true)
        
    }
    
    
    @IBAction func payBtnTap(_ sender: UIButton) {
        
        if cart.count > 0 {
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let destination = storyboard.instantiateViewController(withIdentifier: "AddressController") as! AddressController
//            navigationController?.pushViewController(destination, animated: true)
            
            // TODO: add order data to CoreData
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: "CafesController") as! CafesController
            
            navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payBtn.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExtraCellLines()
        updateTotalCost()
    }
    
    private func updateTotalCost() {
        var total = Int(deliveryCost)!
        
        for product in cart {
            total += Int(product.price)! * product.inCart()
        }
        
        totalCostLabel.text = "Итого: \(total)₽"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            MenuController {
            
            destination.cart = [:]
            
            cart.forEach { (product) in
                destination.cart[product.id] = product
            }
        }
    }

}

extension CartController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == cart.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: DeliveryCostCell.ID, for: indexPath) as! DeliveryCostCell
            cell.deliveryCostLabel.text = "Доставка: \(deliveryCost)₽"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.ID, for: indexPath) as! CartCell
            let product = cart[indexPath.row]
            cell.initData(product: product)
            
            cell.increaseCountAction = {
                self.cart[indexPath.row].add()
                tableView.reloadRows(at: [indexPath], with: .none)
                self.updateTotalCost()
            }
            
            cell.decreaseCountAction = {
                self.cart[indexPath.row].subtract()
                if self.cart[indexPath.row].removeFromCart {
                    self.cart.remove(at: indexPath.row)
    //                tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.reloadData()
                } else  {
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
                
                self.updateTotalCost()
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cart.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.updateTotalCost()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is CartCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: (cell as! CartCell).titleLabel.frame.minX, bottom: 0, right: 0)
        } else {
            cell.separatorInset = .zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == cart.count { return 60 } else { return 100 }
    }
    
}
