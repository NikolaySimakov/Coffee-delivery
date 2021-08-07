//
//  Cafe.swift
//  Coffee-delivery
//
//  Created by User on 09/07/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit
import Foundation

class Cafe {
    
    var title: String!
    var rating: String!
    var imageURL: String!
    var image: UIImage?
    var status: Bool!
    
    init(title: String, rating: String, imageURL: String, image: UIImage?, status: Bool) {
        self.title = title
        self.rating = rating
        self.imageURL = imageURL
        self.image = image
        self.status = status
    }
    
}
