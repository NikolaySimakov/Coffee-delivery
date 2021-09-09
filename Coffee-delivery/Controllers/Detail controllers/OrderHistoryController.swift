//
//  TestController.swift
//  Coffee-delivery
//
//  Created by User on 01/09/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import ExpandableCell

class OrderHistoryController: UIViewController, ExpandableDelegate {
    
    private var orders : [Order] = []
    private let orderHistory = OrderStorage()
    
    @IBOutlet weak var tableView: ExpandableTableView!
    
    var expandedCell: UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testExpendedCell")!
        cell.textLabel!.text = "12345"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.expandableDelegate = self
        tableView.animation = .top
        tableView.expansionStyle = .multi
        tableView.removeExtraCellLines()
        
        
        let order = Order(cafeTitle: "Some title", totalPrice: "123", deliveryDate: Date(), goods: [])
        orderHistory.save(order: order)
        
        if let orders = orderHistory.show() {

            self.orders = orders

            if orders.count == 0 {
                let alert = UIAlertController(title: "Нет истории заказов", message: "Вы еще ничего не заказывали.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ясно", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))

                self.present(alert, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Ой...", message: "Возникла какая-то ошибка.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Назад", style: .default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))

            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderHistoryCell", for: indexPath) as! OrderHistoryCell
        
        cell.arrowImageView.image = nil
        
        cell.titleLabel.text = orders[indexPath.row].cafeTitle
        cell.totalPriceLabel.text = orders[indexPath.row].totalPrice + " ₽"
        cell.deliveryTimeLabel.text = orders[indexPath.row].deliveryDateString()
        
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    @objc(expandableTableView:didCloseRowAt:) func expandableTableView(_ expandableTableView: UITableView, didCloseRowAt indexPath: IndexPath) {
        let cell = expandableTableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        cell?.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
    }
    
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Expanded cells
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        return [60, 60]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        return [expandedCell, expandedCell]
    }
    
}
