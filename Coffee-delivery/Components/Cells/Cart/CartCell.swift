//
//  CartCell.swift
//  Coffee-delivery
//
//  Created by User on 08/07/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import Alamofire


class CartCell: UITableViewCell {
    
    static let ID : String = "cartCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    var decreaseCountAction : (()->())?
    var increaseCountAction : (()->())?
    
    
    @IBAction func decreaseButtonTap(_ sender: UIButton) {
        decreaseCountAction?()
    }
    
    @IBAction func increaseButtonTap(_ sender: UIButton) {
        increaseCountAction?()
    }
    
    
    func initData(product: Product) {
        titleLabel.text = product.title
        priceLabel.text = product.price + "₽"
        countLabel.text = String(product.inCart())
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.layer.cornerRadius = 8
        decreaseButton.layer.cornerRadius = 6
        increaseButton.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
