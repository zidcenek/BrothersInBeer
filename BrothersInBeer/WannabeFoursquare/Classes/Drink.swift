//
//  Drink.swift
//  WannabeFoursquare
//
//  Created by Cenda on 12/02/2020.
//  Copyright © 2020 CVUT. All rights reserved.
//

import Foundation
class Drink{
    var name: String
    var count: Int
    var price: Int
    
    init(name: String, count: Int, price: Int){
        self.name = name
        self.count = count
        self.price = price
    }
    
    public func getName() -> String {
        return self.name
    }
    
    public func getCount() -> Int {
        return self.count
    }
    
    public func getPrice() -> Int {
        return self.price
    }
}
