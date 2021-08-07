//
//  CoffeeParser.swift
//  Coffee-delivery
//
//  Created by User on 14/07/2021.
//  Copyright © 2021 Nikolay Simakov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class CoffeeParser {
    
    private let apiURL : String = "https://coffee-delivery.herokuapp.com/"
//    private let apiURL : String = "http://localhost:5000/"
    
    
    func getImage(_ imageURL : String, _ completion: @escaping (UIImage) -> Void) {
        
        AF.request(imageURL, method: .get).response { response in

           switch response.result {
            case .success(let responseData):
                completion(UIImage(data: responseData!)!)
            
            case .failure(let error):
                print("error: ", error)
            }
        }
    }
    
    
    func fetchCafes(_ completion: @escaping ([Int : Cafe]) -> Void) {
        
        var cafes : [Int : Cafe] = [:]
        
        AF.request(apiURL + "cafes").responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                for i in JSON(value) {
                    cafes[Int(i.0)!] = Cafe(
                        title: i.1["title"].string!,
                        rating: i.1["rating"].string!,
                        imageURL: i.1["image"].string!,
                        image: nil,
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
        
        AF.request(apiURL + "cafes/\(menuID)/menu").responseJSON { (response) in
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

