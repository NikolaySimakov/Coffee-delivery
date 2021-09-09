//
//  DrinkDetailsController.swift
//  Coffee-delivery
//
//  Created by User on 20/07/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

class DrinkDetailsController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceBtn: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var decreaseBtn: UIButton!
    
    @IBAction func increase(_ sender: UIButton) {
        product.add()
        let productQuantity = product.inCart() + 1
        self.priceBtn.setTitle("Добавить \(productQuantity * Int(product.price)!)₽ (\(productQuantity) шт.)", for: .normal)
    }
    
    @IBAction func decrease(_ sender: UIButton) {
        product.subtract()
        let productQuantity = product.inCart() + 1
        if productQuantity == 1 {
            self.priceBtn.setTitle("Добавить \(product.price!)₽", for: .normal)
        } else {
            self.priceBtn.setTitle("Добавить \(productQuantity * Int(product.price)!)₽ (\(productQuantity) шт.)", for: .normal)
        }
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.addProductToCart(productId: product.id)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var datailDescription : String!
    var product : Product!
    
    var delegate : ProductDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceBtn.layer.cornerRadius = 10
        increaseBtn.layer.cornerRadius = 10
        decreaseBtn.layer.cornerRadius = 10
        
        self.imageView.image = product.image
        self.titleLabel.text = product.title
        self.priceBtn.setTitle("Добавить \(product.price!)₽", for: .normal)
    }

}
