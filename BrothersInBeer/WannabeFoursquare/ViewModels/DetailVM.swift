//
//  DetailVM.swift
//  WannabeFoursquare
//
//  Created by Cenda on 13/02/2020.
//  Copyright © 2020 CVUT. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class DetailVM{
    var ses: Session
    
    init(ses: Session) {
        self.ses = ses
    }
    public func getPubName() -> String{
        return ses.getPubName()
    }
    public func getUsername() -> String{
        return ses.getUsername()
    }
    
    public func getDrinks() -> [Drink]{
        return ses.getDrinks()
    }
    
    public func addDrink(drink: Drink){
        ses.addDrink(drink: drink)
        let newCheckinReference = Database.database().reference(withPath: "sessions").child(ses.key).child("drinks").child(drink.getName())
        let dict:NSDictionary = [
            "count": drink.getCount(),
            "price": drink.getPrice()
        ]
        newCheckinReference.setValue(dict)
    }
    public func editDrink(drink: Drink, index: Int){
        ses.editDrink(drink: drink, index: index)
        let newCheckinReference = Database.database().reference(withPath: "sessions").child(ses.key).child("drinks").child(drink.getName())
        let dict:NSDictionary = [
            "count": drink.getCount(),
            "price": drink.getPrice()
        ]
        newCheckinReference.setValue(dict)
    }
    
    public func deleteDrink(drink: Drink, index: Int){
        ses.deleteDrink(index: index)
        let newCheckinReference = Database.database().reference(withPath: "sessions").child(ses.key).child("drinks").child(drink.getName())
        newCheckinReference.setValue(nil)
    }
}
