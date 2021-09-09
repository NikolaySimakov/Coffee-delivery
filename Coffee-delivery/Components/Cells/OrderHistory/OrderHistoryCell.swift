//
//  OrderHistoryCell.swift
//  Coffee-delivery
//
//  Created by User on 30/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import ExpandableCell

class OrderHistoryCell: ExpandableCell {
    
    static let ID : String = "orderHistoryCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
