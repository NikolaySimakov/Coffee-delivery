//
//  ProductCell.swift
//  Coffee-delivery
//
//  Created by User on 25/05/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    static let ID : String = "productCell"
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var decreaseBtn: UIButton!
    
    var decreaseCountAction : (()->())?
    var increaseCountAction : (()->())?
    var addProductAction : (()->())?
    
    @IBAction func decreaseButtonTap(_ sender: UIButton) {
        decreaseCountAction?()
    }
    
    @IBAction func increaseButtonTap(_ sender: UIButton) {
        increaseCountAction?()
    }
    
    @IBAction func priceBtnTap(_ sender: UIButton) {
        addProductAction?()
        countLabel.text = "1"
        priceBtn.isHidden = true
        increaseBtn.isHidden = false
        decreaseBtn.isHidden = false
        countLabel.isHidden = false
    }
    
    func initData(product: Product) {
        titleLabel.text = product.title
        priceBtn.setTitle(product.price + "₽", for: .normal)
        btnsMapping(product.inCart())
    }
    
    func btnsMapping(_ count : Int) {
        priceBtn.isHidden = count > 0
        increaseBtn.isHidden = count == 0
        decreaseBtn.isHidden = count == 0
        countLabel.isHidden = count == 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.cornerRadius = 20
        
        productImageView.clipsToBounds = true
        
        for i in [priceBtn, increaseBtn, decreaseBtn] { i!.layer.cornerRadius = 10 }
    }
    
}
