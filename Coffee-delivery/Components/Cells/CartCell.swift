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
    
    
    func initData(product: Product, count: String) {
        
        AF.request(product.image, method: .get).response{ response in

           switch response.result {
            case .success(let responseData):
                self.productImageView.image = UIImage(data: responseData!)

            case .failure(let error):
                print("error: ", error)
            }
        }
        
        titleLabel.text = product.title
        priceLabel.text = product.price + " ₽"
        countLabel.text = count
        
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.layer.cornerRadius = 5
        decreaseButton.layer.cornerRadius = 4
        increaseButton.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
