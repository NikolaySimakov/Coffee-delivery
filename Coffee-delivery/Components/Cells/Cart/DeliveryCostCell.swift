//
//  DeliveryCostCell.swift
//  Coffee-delivery
//
//  Created by User on 27/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

class DeliveryCostCell: UITableViewCell {
    
    static let ID : String = "deliveryCostCell"
    
    @IBOutlet weak var deliveryCostLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
