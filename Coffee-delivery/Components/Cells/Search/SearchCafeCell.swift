//
//  SearchCafeCell.swift
//  Coffee-delivery
//
//  Created by User on 09/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

class SearchCafeCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = 8
    }
    
    
    func initCafeData( _ cafe : Cafe) {
        titleLabel.text = cafe.title
        scoreLabel.text = "Нет оценок"
        
        if !cafe.status! { self.contentView.alpha = 0.5 } else { self.contentView.alpha = 1 }
    }

}
