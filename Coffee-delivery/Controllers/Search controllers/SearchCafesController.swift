//
//  SearchController.swift
//  Coffee-delivery
//
//  Created by User on 08/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit


enum SearchFor {
    
    case cafes
    case products
    
}


class SearchCafesController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var isSearchBarEmpty: Bool { return searchBar.text?.isEmpty ?? true }
    var searchObjects : [Int : Any] = [:]
    var searchFor : SearchFor!
    
    private var filteredObjects : [Any] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        switch searchFor {
        case .cafes: title = "Поиск кофеен"
        case .products: title = "Поиск напитков"
        default: break
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !isSearchBarEmpty {
            return filteredObjects.count
        }
        
        return searchObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "searchCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
        
        if isSearchBarEmpty {
            
            if let obj = searchObjects[indexPath.row] as? Cafe {
                cell.initCafeData(obj)
            } else if let obj = searchObjects[indexPath.row] as? Product {
                cell.initProductData(obj)
            }
            
        } else {
            
            if let obj = filteredObjects[indexPath.row] as? Cafe {
                cell.initCafeData(obj)
            } else if let obj = filteredObjects[indexPath.row] as? Product {
                cell.initProductData(obj)
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier: "MenuController") as! MenuController
        let cafe = searchObjects[indexPath.row] as! Cafe
        destination.menuID = String(cafe.id)
        destination.title = cafe.title
        navigationController?.pushViewController(destination, animated: true)
        
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}


extension SearchController : UISearchBarDelegate {
    
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
        
        filteredObjects = []
        
        switch searchFor {
            
        case .cafes:
            
            searchObjects.values.forEach { (obj) in
                
                let cafe = obj as! Cafe
                if cafe.title.lowercased().hasPrefix(searchText.lowercased()) {
                    filteredObjects.append(obj)
                }
                
            }
            
        case .products:
            
            searchObjects.values.forEach { (obj) in
                
                let cafe = obj as! Product
                if cafe.title.lowercased().hasPrefix(searchText.lowercased()) {
                    filteredObjects.append(obj)
                }
                
            }
            
        default:
            break
        }
        
        tableView.reloadData()
    }
}


//public extension UITextField {
//
//    override var textInputMode: UITextInputMode? {
//        let locale = Locale(identifier: "ru")
//
//        return UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == locale.languageCode }) ?? super.textInputMode
//    }
//}
