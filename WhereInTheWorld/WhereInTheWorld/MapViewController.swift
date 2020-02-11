//
//  ViewController.swift
//  WhereInTheWorld
//
//  Created by Max Zvyagin on 2/10/20.
//  Copyright © 2020 Max Zvyagin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!{
        didSet{mapView.delegate = self as MKMapViewDelegate}
    }
    @IBOutlet var viewLocation: UILabel!
    @IBOutlet var viewDescription: UILabel!
    
    @IBOutlet var starButton: UIButton!
    
    @IBAction func starButtonTap(_ sender: UIButton) {
        // edit so button image will change
        sender.isSelected = !sender.isSelected
        // add to user defaults holding map location in this function
    }
    
    var all_places = [Place]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // set map view properties
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        // set star button images
        starButton.setImage(UIImage(systemName:"star.fill"), for: .selected)
        starButton.setImage(UIImage(systemName:"star"), for: .normal)
        // load in the data from plist
        // source: https://learnappmaking.com/plist-property-list-swift-how-to/
        var data:NSDictionary? = nil
        let path = Bundle.main.path(forResource: "Data", ofType: "plist")!
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
            self.all_places.append(new_place)
        }
        self.mapView.addAnnotations(self.all_places)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // source: https://www.raywenderlich.com/548-mapkit-tutorial-getting-started
        // source: location services storyboard
        // set chicago coordinates
        let regionRadius : CLLocationDistance = 10000
        let chicagoCenter = CLLocationCoordinate2D(latitude: CLLocationDegrees(41.881832), longitude: CLLocationDegrees(-87.623177))
        let chicagoRegion = MKCoordinateRegion(center: chicagoCenter, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(chicagoRegion, animated: true)
    }
}

// source: location services example from class
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        return PlaceMarkerView()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        let annot = view.annotation as! Place
        self.viewLocation.text = annot.name
        self.viewDescription.text = annot.longDescription
    }
    
}

