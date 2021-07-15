//
//  Parse.swift
//  Coffee-delivery
//
//  Created by User on 14/07/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class CoffeeParser {
    
    private let apiURL : String = "https://coffee-delivery-tests.herokuapp.com"
    
    
    func fetchCafes(_ completion: @escaping ([Int : Cafe]) -> Void) {
        
        var cafes : [Int : Cafe] = [:]
        
        AF.request(apiURL + "/cafes").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for i in json {
                    cafes[Int(i.0)!] = Cafe(
                        title: i.1["title"].string!,
                        body: i.1["body"].string!,
                        image: i.1["image"].string!,
                        status: i.1["status"].bool!
                    )
                }
                
                completion(cafes)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func fetchGoods(menuID : String, _ completion: @escaping ([Int : Product]) -> Void) {
        
        var goods : [Int : Product] = [:]
        
        AF.request(apiURL + "/cafes/\(menuID)/menu").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for i in json["goods"] {
                    goods[Int(i.0)!] = Product(
                        title: i.1["title"].string!,
                        price: i.1["price"].string!,
                        image: i.1["image"].string!
                    )
                }
                
                completion(goods)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func sendOrder(cart: [(Product, Int)]) {
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
        
        AF.request(apiURL + "/orders", method: .post, parameters: params).responseJSON { response in
            print(response)
        }
        
    }
    
}

