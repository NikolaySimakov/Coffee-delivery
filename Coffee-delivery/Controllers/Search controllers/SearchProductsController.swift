//
//  SearchProductsController.swift
//  Coffee-delivery
//
//  Created by User on 14/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

class SearchProductsController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var isSearchBarEmpty: Bool { return searchBar.text?.isEmpty ?? true }
    private var filteredGoods : [Product] = []
    
    var searchGoods : [Product] = []
    var detailDelegate : ProductDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.removeExtraCellLines()
        searchBar.delegate = self
        title = "Напитки"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !isSearchBarEmpty {
            return filteredGoods.count
        }
        
        return searchGoods.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchProductCell.ID, for: indexPath) as! SearchProductCell

        
        var goodsArray : [Product] = []
        if isSearchBarEmpty { goodsArray = searchGoods } else { goodsArray = filteredGoods }
        
        let product = goodsArray[indexPath.row]
        cell.titleLabel.text = product.title
        cell.productImageView.image = product.image
        
        loadImageIfNeeded(array: goodsArray, row: indexPath.row, cell: cell)
        

        return cell
    }
    
    private func loadImageIfNeeded(array: [Product], row: Int, cell: SearchProductCell) {
        if let img = array[row].image {
            cell.productImageView.image = img
        } else {
            let imgParser = ImageParser()
            imgParser.getImage(array[row].imageURL!) { (img) in
                array[row].image = img
                self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DrinkDetailController {
            if let row = tableView.indexPathsForSelectedRows?.last?.row {
                
                var product : Product!
                if isSearchBarEmpty { product = searchGoods[row] } else { product = filteredGoods[row] }
                
                destination.product = product
                destination.delegate = detailDelegate
            }
        }
    }
}

extension SearchProductsController: UISearchBarDelegate {
    
    // MARK: - Search bar delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContent(for: searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true) // remove keyboard
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        tableView.reloadData()
        view.endEditing(true) // remove keyboard
    }
    
    func filterContent(for searchText: String) {
        
        filteredGoods = searchGoods.filter { (product) -> Bool in
            let splittedTitle = product.title.lowercased().components(separatedBy: [",", " ", "!", ".", "?", "«"])
            let coincidences = splittedTitle.filter { (t) -> Bool in
                return t.hasPrefix(searchText.lowercased())
            }
            return coincidences.count > 0
        }
        
        tableView.reloadData()
    }
}
