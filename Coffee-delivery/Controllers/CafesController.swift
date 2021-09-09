//
//  CafesController.swift
//  Coffee-delivery
//
//  Created by User on 19/05/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit


class CafesController: UITableViewController {

    private var cafes : [Int : Cafe] = [:]
    private let parser = CoffeeParser()
    
    @IBOutlet weak var addressBtn: UIButton!
    @IBAction func addressBtnTapped(_ sender: UIButton) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAddress()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressBtn.layer.cornerRadius = 8
        setupRefreshControl()
        updateCafes()
        
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCafes(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.refreshControl!.beginRefreshing()
    }
    
    private func updateCafes() {
        parser.fetchCafes { cafes in
            
            self.cafes = cafes
            self.tableView.reloadData()
            self.tableView.refreshControl!.endRefreshing()
            
        }
    }
    
    private func setupAddress() {
        let defaults = UserDefaults.standard
        let address = defaults.string(forKey: "Address")
        if address != nil {
            self.addressBtn.setTitle(address, for: .normal)
        }
    }

    @objc private func refreshCafes(_ sender: Any) {
        updateCafes()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CafeCell.ID, for: indexPath) as! CafeCell
        cell.initData(cafe: cafes[indexPath.row]!)
        
        loadImageIfNeeded(cafes: cafes, row: indexPath.row, cell: cell)
        
        return cell
    }
    
    private func loadImageIfNeeded(cafes: [Int : Cafe], row: Int, cell: CafeCell) {
        if let img = cafes[row]!.image {
            cell.shopImage.image = img
        } else {
            parser.getImage(cafes[row]!.imageURL!) { (img) in
                cafes[row]!.image = img
                self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 325
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if cafes[indexPath.row]!.status { return indexPath } else { return nil }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            MenuController, let index = tableView.indexPathForSelectedRow {
            destination.menuID = String(index.row)
            destination.title = cafes[index.row]?.title
        } else if let destination = segue.destination as?
            SearchCafesController {
            destination.searchCafes = [Cafe](cafes.values)
        }
//        if let destination = segue.destination as? AddressController {}
    }

}
