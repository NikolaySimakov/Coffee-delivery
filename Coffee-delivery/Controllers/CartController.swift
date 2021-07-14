//
//  CartViewController.swift
//  Coffee-delivery
//
//  Created by User on 16/06/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

class CartController: UIViewController {
    
    var cart : [(Product, Int)] = [] // [product, count]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payBtn: UIButton!
    
    @IBAction func payBtnTap(_ sender: UIButton) {
        
        
    }
    
    
    private var someCount = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payBtn.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExtraCellLines()
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cart.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension UITableView {
    
    func removeExtraCellLines() {
        tableFooterView = UIView(frame: .zero)
    }
    
}
