//
//  AddressController.swift
//  Coffee-delivery
//
//  Created by User on 16/07/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import MapKit

class AddressController: UIViewController {
    
    var cart : [Product]?
    private var searchBarIsEmpty: Bool { return searchBar.text?.isEmpty ?? true }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addAddressBtn: UIButton!
    
    @IBAction func addAddress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addAddressBtn.layer.cornerRadius = 10
        
        searchBar.delegate = self
        searchBar.text = currentAddress() ?? ""
        stylizeSearchBar()
    }

    private func stylizeSearchBar() {
        
        // background
        searchBar.compatibleSearchTextField.backgroundColor = .white
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = .clear
        searchBar.setCenteredPlaceHolder()
        
        // shadow
        searchBar.searchTextField.layer.shadowColor = UIColor.black.cgColor
        searchBar.searchTextField.layer.shadowOpacity = 0.1
        searchBar.searchTextField.layer.shadowOffset = CGSize(width: 0, height: 3)
        searchBar.searchTextField.layer.shadowRadius = 5
    }

    private func currentAddress() -> String? {
        let defaults = UserDefaults.standard
        let address = defaults.string(forKey: "Address")
        return address
    }
    
    
}

extension AddressController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.removeCenteredPlaceHolder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBarIsEmpty {
            searchBar.setCenteredPlaceHolder()
        } else {
            searchBar.removeCenteredPlaceHolder()
        }
    }
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.setCenteredPlaceHolder()
//    }
    
}
