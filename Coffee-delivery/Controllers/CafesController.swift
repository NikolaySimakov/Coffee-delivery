//
//  CafesController.swift
//  Coffee-delivery
//
//  Created by User on 19/05/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "shopCell"

class CafesController: UITableViewController {

    private var cafes : [Int : Cafe] = [:]
    
    
    @IBOutlet weak var addressBtn: UIButton!
    @IBAction func addressBtnTap(_ sender: UIButton) {
        addressAlert()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAddress()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressBtn.layer.cornerRadius = 8
        
        let parser = CoffeeParser()
        
        parser.fetchCafes { cafes in
            
            self.cafes = cafes
            self.tableView.reloadData()
            
        }
    }
    
    
    private func setupAddress() {
        let defaults = UserDefaults.standard
        let address = defaults.string(forKey: "Address")
        if address != nil {
            self.addressBtn.setTitle(address, for: .normal)
        }
    }
    
    
    private func addressAlert() {
        let alert = UIAlertController(title: "Укажите свой адрес", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            let defaultMessage = "Добавить адрес"
            textField.placeholder = defaultMessage
            if self.addressBtn.currentTitle != defaultMessage {
                textField.text = self.addressBtn.currentTitle
            }
            textField.clearButtonMode = .always
        })

        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
            
            if let address = alert.textFields?.first?.text {
                self.addressBtn.setTitle(address, for: .normal)
                let defaults = UserDefaults.standard
                defaults.set(address, forKey: "Address")
            }
        }))

        self.present(alert, animated: true)
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ShopCell
        cell.initData(cafe: cafes[indexPath.row]!)
        let parser = CoffeeParser()
        if cafes[indexPath.row]!.image == nil {
            parser.getImage(cafes[indexPath.row]!.imageURL!) { (img) in
                cell.shopImage.image = img
                self.cafes[indexPath.row]!.image = img
            }
        } else {
            cell.shopImage.image = cafes[indexPath.row]!.image
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 325
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            MenuController, let index = tableView.indexPathForSelectedRow {
            destination.menuID = String(index.row)
            destination.title = cafes[index.row]?.title
        }
    }
    

}

