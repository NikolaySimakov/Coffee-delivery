//
//  Order.swift
//  Coffee-delivery
//
//  Created by User on 12/08/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class PostOrder {
    
    func sendOrder(cart: [(Product, Int)], address : String = "") {
        var data = [String : [String : Any]]()
        let userId = UIDevice.current.identifierForVendor?.uuidString
        
        for i in 0..<cart.count {
            let (product, count) = cart[i]
            
            data[String(i)] = [
                "title" : product.title,
                "price" : product.price,
                "count" : count
            ]
        }
        
        let params : [String : Any] = [
            "userId" : userId!,
            "goods" : data
        ]
        
        AF.request(apiURL + "orders", method: .post, parameters: params).responseJSON { response in
            print(response)
        }
        
    }
    
}
