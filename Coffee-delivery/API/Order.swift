//
//  Order.swift
//  Coffee-delivery
//
//  Created by User on 30/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import Foundation

class Order : NSObject {
    
    var cafeTitle : String!
    var totalPrice : String!
    var deliveryDate : Date?
    var goods : [Product]!
    
    init(cafeTitle: String, totalPrice: String, deliveryDate: Date? = nil, goods: [Product]) {
        self.cafeTitle = cafeTitle
        self.totalPrice = totalPrice
        self.deliveryDate = deliveryDate
        self.goods = goods
    }
    
    func deliveryDateString() -> String {
        if self.deliveryDate == nil { return "В процессе доставки" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let day = dateFormatter.string(from: self.deliveryDate!)
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: self.deliveryDate!)
        
        return "Доставлено в \(time), \(day)"
    }
    
}
