//
//  SessionTableViewModel.swift
//  WannabeFoursquare
//
//  Created by Cenda on 13/02/2020.
//  Copyright © 2020 CVUT. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class SessionTableViewModel {
    public var drinkingSessions = [Session]()
    
    public func fillCell(indexPath: Int) -> CellViewModel{
        let ses = drinkingSessions[indexPath]
        return CellViewModel(ses: ses)
    }
    public func getDetailVM(indexPath: Int) -> DetailVM {
        let ses = drinkingSessions[indexPath]
        return DetailVM(ses: ses)
    }
    
    public func addDrinkingSession(name: String, userID: String){
        let newCheckinReference = Database.database().reference(withPath: "sessions").childByAutoId()
        //let newChechinID = newCheckinReference.key
        let dict:NSDictionary = [
            "pub": name,
            "user": userID       ]
        print("setting session")
        newCheckinReference.setValue(dict)
        
    }
        public func loadSessions() -> [Session]{
            return self.drinkingSessions
        }
}
