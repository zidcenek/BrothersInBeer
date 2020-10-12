//
//  Session.swift
//  WannabeFoursquare
//
//  Created by Cenda on 12/02/2020.
//  Copyright © 2020 CVUT. All rights reserved.
//

import Foundation

class Session {
    var pub: String
    var timestamp: Double
    var user: String
    var drinks: [Drink]
    var key: String
    
    init(pub: String, timestamp: Double, user: String, key: String) {
        self.pub = pub
        self.timestamp = timestamp
        self.user = user
        self.drinks = [Drink]()
        self.key = key
    }
    public func getPubName() -> String {
        return pub
    }
    public func getUsername() -> String {
        return user
    }
    public func getDrinks() -> [Drink]{
        return drinks
    }
    public func addDrink(drink: Drink){
        drinks.append(drink)
    }
    public func editDrink(drink: Drink, index: Int){
        drinks[index] = drink
    }
    public func deleteDrink(index: Int){
        drinks.remove(at: index)
    }
}
