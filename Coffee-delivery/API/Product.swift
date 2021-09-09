//
//  Product.swift
//  Coffee-delivery
//
//  Created by User on 09/07/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

class Product : NSObject {
    
    var id: Int!
    
    var title: String!
    var price: String!
    var imageURL: String!
    var image: UIImage?
    
    private var quantityInStock: Int!
    private var quantityInCart: Int = 0
    var removeFromCart: Bool { return quantityInCart == 0 }
    
    init(id: Int, title: String, price: String, imageURL: String, quantityInStock: Int) {
        self.id = id
        self.title = title
        self.price = price
        self.imageURL = imageURL
        self.quantityInStock = quantityInStock
    }
    
    // MARK: - Quantity in cart
    
    func add( _ count: Int = 1) {
        self.quantityInCart = min(
            self.quantityInCart + count,
            quantityInStock
        )
    }

    func subtract() {
        self.quantityInCart = max(
            self.quantityInCart - 1,
            0
        )
    }
    
    func inCart() -> Int {
        return quantityInCart
    }
    
}
