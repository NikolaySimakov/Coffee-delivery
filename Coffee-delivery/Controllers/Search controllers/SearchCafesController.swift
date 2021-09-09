//
//  SearchCafesController.swift
//  Coffee-delivery
//
//  Created by User on 08/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit


class SearchCafesController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var isSearchBarEmpty: Bool { return searchBar.text?.isEmpty ?? true }
    var searchCafes : [Cafe] = []
    
    private var filteredCafes : [Cafe] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.removeExtraCellLines()
        searchBar.delegate = self
        title = "Кофейни"
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !isSearchBarEmpty {
            return filteredCafes.count
        }
        
        return searchCafes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCafeCell.ID, for: indexPath) as! SearchCafeCell
        
        var cafesArray : [Cafe] = []
        if isSearchBarEmpty { cafesArray = searchCafes } else { cafesArray = filteredCafes }
        
        let cafe = cafesArray[indexPath.row]
        cell.initCafeData(cafe)
        loadImageIfNeeded(array: cafesArray, row: indexPath.row, cell: cell)
        
        return cell
    }
    
    private func loadImageIfNeeded(array: [Cafe], row: Int, cell: SearchCafeCell) {
        if let img = array[row].image {
            cell.imgView.image = img
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier: "MenuController") as! MenuController
        
        var cafe : Cafe!
        if isSearchBarEmpty { cafe = searchCafes[indexPath.row] } else { cafe = filteredCafes[indexPath.row] }
        
        destination.menuID = String(cafe.id)
        destination.title = cafe.title
        navigationController?.pushViewController(destination, animated: true)

    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if isSearchBarEmpty {
            if searchCafes[indexPath.row].status { return indexPath } else { return nil }
        } else {
            if filteredCafes[indexPath.row].status { return indexPath } else { return nil }
        }
    }
}


extension SearchCafesController : UISearchBarDelegate {
    
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
        
        filteredCafes = searchCafes.filter { (cafe) -> Bool in
            let splittedTitle = cafe.title.lowercased().components(separatedBy: [",", " ", "!", ".", "?", "«"])
            let coincidences = splittedTitle.filter { (t) -> Bool in
                return t.hasPrefix(searchText.lowercased())
            }
            return coincidences.count > 0
        }
        
        tableView.reloadData()
    }
}
