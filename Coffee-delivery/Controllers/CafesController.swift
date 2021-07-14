//
//  CafesController.swift
//  Coffee-delivery
//
//  Created by User on 19/05/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON


class CafesController: UITableViewController {

    private let apiURL : String = "http://localhost:5000/cafes"
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
        fetchRestaurantData()
    }
    
    
    private func fetchRestaurantData() {
        AF.request(apiURL).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    for i in json {
                        self.cafes[Int(i.0)!] = Cafe(
                                title: i.1["title"].string!,
                                body: i.1["body"].string!,
                                image: i.1["image"].string!
                            )
                    }
                    self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ShopCell
        cell.selectionStyle = .none
        cell.initData(cafe: cafes[indexPath.row]!)
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 325
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
            MenuController, let index = tableView.indexPathForSelectedRow {
            destination.menuID = String(index.row)
            destination.title = cafes[index.row]?.title
            destination.fetchMenuData()
        }
    }
    

}

