//
//  JTLVenueModel.swift
//  Jump-The-Line
//
//  Created by Ivan Yanakiev on 2/10/16.
//  Copyright © 2016 Kriviq. All rights reserved.
//

import Foundation
import ObjectMapper

class JTLVenueModel: NSObject, Mappable {
    var name: String!
    var id: String!
    var places : Array<String>?
//    var age: Int?
//      var weight: Double!
    
    required init?(_ map: Map) {
        
    }
    
    init(name : String, places: Array<String>) {
        self.name = name;
        self.places = places;
    }
    
    func inquireAboutPlaces() {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        name    <- map["name"]
        id <- map["id"]
//        age     <- map["age"]
//        weight  <- map["weight"]
    }
}