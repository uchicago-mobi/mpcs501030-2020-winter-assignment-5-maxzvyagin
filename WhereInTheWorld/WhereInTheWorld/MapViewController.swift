//
//  ViewController.swift
//  WhereInTheWorld
//
//  Created by Max Zvyagin on 2/10/20.
//  Copyright © 2020 Max Zvyagin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, PlacesFavoriteDelegate {
    
    @IBOutlet var mapView: MKMapView!{
        didSet{mapView.delegate = self as MKMapViewDelegate}
    }
    @IBOutlet var viewLocation: UILabel!
    @IBOutlet var viewDescription: UILabel!
    @IBOutlet var favButton: UIButton!
    
    
    @IBOutlet var starButton: UIButton!
    
    var currentPlace: Place? = nil
    
    var allPlaces = [Place]()
    
    let defaults = UserDefaults.standard
    
    @IBAction func starButtonTap(_ sender: UIButton) {
        // if it is currently selected, remove from favorites
        if DataManager.sharedInstance.favorites.contains(currentPlace?.name ?? "blank"){
            DataManager.sharedInstance.deleteFavorite(place: currentPlace?.name ?? "blank")
        }
        // need to have this in case someone hits the star when it's on a pin with multiple things
        else if currentPlace?.name == nil{
            return
        }
        // else add to the favorites
        else{
            DataManager.sharedInstance.favorites.append(currentPlace!.name!)
        }
        // edit so button image will change
        sender.isSelected = !sender.isSelected
        // add to user defaults holding map location in this function
    }
    
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
        let places = DataManager.sharedInstance.loadAnnotationFromPlist(filename:"Data")
        self.allPlaces = places // save the list of all places
        self.mapView.addAnnotations(places)
        // edit favorites button
        self.favButton.layer.cornerRadius=10
    }
    
    // not sure if this is right with the table view segue
    override func viewWillAppear(_ animated: Bool) {
        // source: https://www.raywenderlich.com/548-mapkit-tutorial-getting-started
        // source: location services storyboard
        // set chicago coordinates
        let regionRadius : CLLocationDistance = 10000
        let chicagoCenter = CLLocationCoordinate2D(latitude: CLLocationDegrees(41.881832), longitude: CLLocationDegrees(-87.623177))
        let chicagoRegion = MKCoordinateRegion(center: chicagoCenter, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(chicagoRegion, animated: true)
    }
    
    // move the map to the favorite place
    func favoritePlace(name: String) {
        var selectedPlace:Place? = nil
        // find the place with this name
        for x in self.allPlaces{
            if x.name == name{
                selectedPlace = x
                break
            }
        }
        
        // couldn't find the selected place, this shouldn't ever happen though
        if selectedPlace == nil{
            return
        }
        
        // else move the map to the selected place and update labels
        let regionRadius : CLLocationDistance = 500
        let chicagoRegion = MKCoordinateRegion(center: selectedPlace!.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(chicagoRegion, animated: true)
        
        self.viewLocation.text = selectedPlace?.name
        self.viewDescription.text = selectedPlace?.longDescription
        self.starButton.isSelected = true
        
        self.currentPlace = selectedPlace
        
    }
    
    // source: https://iosdevcenters.blogspot.com/2017/11/what-is-protocol-how-to-pop-data-using.html
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! FavoritesTableViewController
        destination.delegate = self
    }
    
}

// source: location services example from class
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        return PlaceMarkerView()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        let annot = view.annotation as? Place
        self.currentPlace = annot
        self.viewLocation.text = annot?.name
        self.viewDescription.text = annot?.longDescription
        if DataManager.sharedInstance.favorites.contains(annot?.name ?? "blank"){
            // set star button to be selected
            starButton.isSelected = true
        }
        else{
            starButton.isSelected = false
        }
    }
    
}


