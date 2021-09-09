//
//  Cafe.swift
//  Coffee-delivery
//
//  Created by User on 09/07/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import UIKit

class Cafe : NSObject {
    
    var id: Int!
    var title: String!
    var rating: String!
    var imageURL: String!
    var image: UIImage?
    var status: Bool!
    
    init(id: Int, title: String, rating: String, imageURL: String, status: Bool) {
        self.id = id
        self.title = title
        self.rating = rating
        self.imageURL = imageURL
        self.status = status
    }
    
}
