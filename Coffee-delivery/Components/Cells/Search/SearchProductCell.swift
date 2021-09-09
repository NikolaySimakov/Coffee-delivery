//
//  SearchProductCell.swift
//  Coffee-delivery
//
//  Created by User on 26/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

class SearchProductCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.layer.cornerRadius = productImageView.frame.size.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
