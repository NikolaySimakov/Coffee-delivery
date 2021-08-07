//
//  CartViewController.swift
//  Coffee-delivery
//
//  Created by User on 16/06/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class CartController: UIViewController {
    
    var cart : [(Product, Int)] = [] // [product, count]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    @IBAction func payBtnTap(_ sender: UIButton) {
        let parser = CoffeeParser()
        parser.sendOrder(cart: cart)
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
        var total = 0
        
        for (p, c) in cart {
            total += Int(p.price)! * c
        }
        
        totalCostLabel.text = "Итого: \(total) ₽"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            MenuController {
//            for data in cart {
//                destination.cart.append(data.value)
//            }
        }
    }

}

extension CartController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartCell
        let product = cart[indexPath.row].0
        let count = String(cart[indexPath.row].1)
        cell.initData(product: product, count: count)
        
        cell.increaseCountAction = {
            self.cart[indexPath.row] = (self.cart[indexPath.row].0, self.cart[indexPath.row].1 + 1)
            tableView.reloadRows(at: [indexPath], with: .none)
            self.updateTotalCost()
        }
        
        cell.decreaseCountAction = {
            self.cart[indexPath.row] = (self.cart[indexPath.row].0, max(self.cart[indexPath.row].1 - 1, 0))
            if self.cart[indexPath.row].1 == 0 {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cart.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.updateTotalCost()
        }
    }
    
    
    
}

extension UITableView {
    
    func removeExtraCellLines() {
        tableFooterView = UIView(frame: .zero)
    }
    
}
