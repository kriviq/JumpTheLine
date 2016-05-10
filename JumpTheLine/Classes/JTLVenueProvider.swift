//
//  JTLVenueProvider.swift
//  Jump-The-Line
//
//  Created by Ivan Yanakiev on 2/7/16.
//  Copyright © 2016 Kriviq. All rights reserved.
//

import UIKit
import QuadratTouch
import CoreLocation
import ObjectMapper

class JTLVenueProvider: NSObject, CLLocationManagerDelegate {
    
     static let sharedInstance = JTLVenueProvider()
    
    ///LOCATION STUFF
    var locationManager: CLLocationManager = CLLocationManager();
    var session: Session!
    ///LOCATION STUFF
    
    var cityLocationDictionary: NSDictionary!
    
    func initDictionary() {
        let parisLocation = CLLocation(latitude: 48.8567, longitude: 2.3508);
        let edinburgLocation = CLLocation(latitude: 55.9531, longitude: -3.1889);
        self.cityLocationDictionary = ["Paris" : parisLocation,
            "Edinburgh" : edinburgLocation]
            
    }
    
    func venueForCityAndName(city:String, category:String, venueName:String, handler: (places:NSArray) -> Void) {
        var parameters = [Parameter.query:venueName]
        let location = self.cityLocationDictionary[city] as! CLLocation;
        
        parameters += location.parameters()
        parameters += [Parameter.limit:"2"]
        parameters += [Parameter.section:category]
        
        let searchTask = session.venues.explore(parameters) {
            
            (result) -> Void in
            self.responseParsers(result, handler: handler);
        }
        searchTask.start()
    }
    
    func responseParsers(result: Result, handler: (places:NSArray) -> Void) {
        if let response = result.response {
            
            
//            let objects = NSMutableArray()
//            let venues = response["venues"] as! NSArray
//            for venue in venues {
//                let object = Mapper<JTLVenueModel>().map(venue)
////                NSLog("object that was created is %@", object!.name)
//                objects.addObject(object!)
//            }
//            
//            handler(places: objects);
            NSLog("response is %@", response);
        }

    }
    
    func venuesForCity(city:String, handler: (places:NSArray) -> Void) {
        var parameters = [Parameter.query:"Club"]
        let location = self.cityLocationDictionary[city] as! CLLocation;
        
        parameters += location.parameters()
        parameters += [Parameter.limit:"2"]
        
        let searchTask = session.venues.search(parameters) {
            (result) -> Void in
            if let response = result.response {
                NSLog("response %@", response)
                
                let objects = NSMutableArray()
                let venues = response["venues"] as! NSArray
                for venue in venues {
                    let object = Mapper<JTLVenueModel>().map(venue)
                    NSLog("object that was created is %@", object!.name)
                    objects.addObject(object!)
                }
                
                handler(places: objects);
                NSLog("response is %@", response);
            }
        }
        searchTask.start()
        
        
        //let searchTask = session.venues.sear(<#T##venueId: String##String#>)
        
    }
    
    func venuesForLocation(location:CLLocation, handler: (places:NSArray) -> Void) {
        let searchQuery = String(format: "%@", arguments: ["Burgers"]);
        NSLog("searchQuery %@", searchQuery);
        var parameters = [Parameter.query:searchQuery]
        parameters += location.parameters()
        let searchTask = session.venues.explore(parameters) {
            (result) -> Void in
            if let response = result.response {
                NSLog("response is %@", response);
                //                self.venues = response["venues"] as [JSONParameters]?
                //                self.tableView.reloadData()
            }
        }
        searchTask.start()
        
    }
    
    func start() {
        let client = Client(clientID:       "UF3UFNX2GGOP3MP5S1R2NXXPSPNTN1QWSBEAJVDXRH1R0RM0",
            clientSecret:   "RR235ZSH0ZNDCXSBXMX5OLBXZIH0ZQKSLCYLLDTZHRHVZC1I",
            redirectURL:    "jtl://foursquare")
        var configuration = Configuration(client:client)
        Session.setupSharedSessionWithConfiguration(configuration)
        
        session = Session.sharedSession()
    }
 
    override init() {
        super.init()
        
        self.initDictionary()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        NSLog("determinded regeion")
    }
    
    func locationManager(manager: CLLocationManager, rangingBeaconsDidFailForRegion region: CLBeaconRegion, withError error: NSError) {
        NSLog("failed with errror rangingBeaconsDidFailForRegion %@", error);
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("failed with errror %@", error.description);
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        NSLog("authorization state changed %i", status.rawValue);
        if status == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            NSLog("authorized!")
            //            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        var parameters = [Parameter.query:"Paris Burgers"]
//        parameters += locations[0].parameters()
//        let searchTask = session.venues.search(parameters) {
//            (result) -> Void in
//            if let response = result.response {
//                NSLog("response is %@", response);
//                //                self.venues = response["venues"] as [JSONParameters]?
//                //                self.tableView.reloadData()
//            }
//        }
//        searchTask.start()
        
    }
}


extension CLLocation {
    func parameters() -> Parameters {
        let ll      = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let llAcc   = "\(self.horizontalAccuracy)"
        let alt     = "\(self.altitude)"
        let altAcc  = "\(self.verticalAccuracy)"
        let parameters = [
            Parameter.ll:ll,
            Parameter.llAcc:llAcc,
            Parameter.alt:alt,
            Parameter.altAcc:altAcc
        ]
        return parameters
    }
}
