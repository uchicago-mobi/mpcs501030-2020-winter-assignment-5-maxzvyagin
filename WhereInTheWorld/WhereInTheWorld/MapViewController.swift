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
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
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

