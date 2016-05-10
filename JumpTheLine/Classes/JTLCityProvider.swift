//
//  JTLCityProvider.swift
//  Jump-The-Line
//
//  Created by Ivan Yanakiev on 2/1/16.
//  Copyright © 2016 Kriviq. All rights reserved.
//

import UIKit

let locationsFileName: String = "JTLLocations"
let citiesKey: String = "cities"
let currentCityKey:String = "currentCity"

class JTLCityProvider: NSObject {
    
    var plistData: NSDictionary?
    static let sharedInstance = JTLCityProvider()
    
    func currentCity() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey(currentCityKey)
    }
    
    func setCurrentCity(city: String) {
        NSUserDefaults.standardUserDefaults().setObject(city, forKey: currentCityKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func cities() -> NSArray {
        return self.locationsData()[citiesKey] as! NSArray
    }
    
    func locationsData() -> NSDictionary {
        if (plistData == nil) {
            if let path = NSBundle.mainBundle().pathForResource(locationsFileName, ofType: ".plist") {
                plistData = NSDictionary(contentsOfFile: path)
            }
        }
        return plistData!
    }
    
}

extension JTLCityProvider {
    

}