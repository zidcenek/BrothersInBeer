//
//  Pub.swift
//  WannabeFoursquare
//
//  Created by Cenda on 12/02/2020.
//  Copyright © 2020 CVUT. All rights reserved.
//
import Foundation

class Pub: NSObject{
    var name: String
    var type: String
    var lat: Double
    var lon: Double
    
    init(name: String, type: String, lat: Double, lon: Double) {
        self.name = name
        self.type = type
        self.lat = lat
        self.lon = lon
    }
    public func areNils() -> Bool{
        return !(self.name != nil && self.lat != nil  && self.lon != nil && self.type != nil)
    }
}
