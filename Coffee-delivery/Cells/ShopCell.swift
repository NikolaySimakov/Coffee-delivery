//
//  MainCell.swift
//  Coffee-delivery
//
//  Created by User on 19/05/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import Alamofire

class ShopCell: UITableViewCell {
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initData(cafe: Cafe) {
        
        AF.request(cafe.image, method: .get).response{ response in

           switch response.result {
            case .success(let responseData):
                self.shopImage.image = UIImage(data: responseData!)

            case .failure(let error):
                print("error: ", error)
            }
        }
        
        shopImage.layer.cornerRadius = 20
        shopImage.clipsToBounds = true
        nameLabel.text = cafe.title
        descriptionLabel.text = cafe.body
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


