//
//  ShopCell.swift
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
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shopImage.layer.cornerRadius = 20
        shopImage.clipsToBounds = true
        
    }
    
    func initData(cafe: Cafe) {
        
        selectionStyle = .none
        shopImage.image = cafe.image
        shopImage.layer.cornerRadius = 20
        shopImage.clipsToBounds = true
        nameLabel.text = cafe.title
        ratingLabel.text = cafe.rating
        if !cafe.status! { self.contentView.alpha = 0.5 } else { self.contentView.alpha = 1 }
    }
    
}


