//
//  OrderHistoryDetailCell.swift
//  Coffee-delivery
//
//  Created by User on 05/09/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

class OrderHistoryDetailCell: UITableViewCell {
    
    static let ID : String = "orderHistoryDetailCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
