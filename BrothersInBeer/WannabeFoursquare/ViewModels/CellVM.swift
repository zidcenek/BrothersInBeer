//
//  CellVM.swift
//  WannabeFoursquare
//
//  Created by Cenda on 13/02/2020.
//  Copyright © 2020 CVUT. All rights reserved.
//

import Foundation

class CellViewModel{
    var ses: Session
    
    init(ses: Session) {
        self.ses = ses
    }
    public func getPubName() -> String{
        return ses.getPubName()
    }
}
