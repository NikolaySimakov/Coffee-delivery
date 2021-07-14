//
//  ProductCell.swift
//  Coffee-delivery
//
//  Created by User on 25/05/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import Alamofire

class ProductCell: UICollectionViewCell {
    
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceBtn: UIButton!
    
    var addProductAction : (()->())?
    
    
    @IBAction func priceBtnTap(_ sender: UIButton) {
//        productBtn.setTitle("Добавлено", for: .normal)
        addProductAction?()
    }
    
    
    func initData(product: Product) {
        
        AF.request(product.image, method: .get).response{ response in

           switch response.result {
            case .success(let responseData):
                self.productImageView.image = UIImage(data: responseData!)

            case .failure(let error):
                print("error: ", error)
            }
        }
        
        titleLabel.text = product.title
        priceBtn.setTitle(product.price + " ₽", for: .normal)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.clipsToBounds = true
        priceBtn.layer.cornerRadius = 10
    }
    
    
}
