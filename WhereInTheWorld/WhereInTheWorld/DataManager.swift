//
//  DataManager.swift
//  WhereInTheWorld
//
//  Created by Max Zvyagin on 2/13/20.
//  Copyright © 2020 Max Zvyagin. All rights reserved.
//

import Foundation
import MapKit

public class DataManager{
    
    // static stuff
    public static let sharedInstance = DataManager()
    // this prevents others from using the default init
    fileprivate init() {}
    
    // initialize a global array to keep track of favorites
    var favorites = [String]()
    
    func loadAnnotationFromPlist(filename:String)->[Place]{
       // source: https://learnappmaking.com/plist-property-list-swift-how-to/
       var retArray = [Place]()
       var data:NSDictionary? = nil
       let path = Bundle.main.path(forResource: filename, ofType: "plist")!
       let xml = FileManager.default.contents(atPath: path)
       do{
           data = try!  PropertyListSerialization.propertyList(from:xml!, options:.mutableContainersAndLeaves, format: nil) as! [String:AnyObject] as NSDictionary
       }
       let places: NSArray = data?.value(forKey: "places") as! NSArray
       for x in places{
           let n = (x as! NSDictionary).value(forKey:"name") as! String
           let des = (x as! NSDictionary).value(forKey:"description") as! String
           let lat:CLLocationDegrees = (x as! NSDictionary).value(forKey:"lat") as! CLLocationDegrees
           let long:CLLocationDegrees = (x as! NSDictionary).value(forKey:"long") as! CLLocationDegrees
           let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
           // initialize place class
           let new_place = Place(__coordinate: coord, title: n, subtitle: des)
           new_place.name = n
           new_place.longDescription = des
           retArray.append(new_place)
       }
       return retArray
    }
    
    // save favorites upon exiting
    func saveFavorites(){
        
        return
    }
    
    
    func deleteFavorite(place: String){
        guard let index = favorites.firstIndex(of: place) else { return }
        favorites.remove(at: index)
        
    }
    
    func listFavorites(){
        for x in self.favorites{
            print(x)
        }
        
    }
    
}
