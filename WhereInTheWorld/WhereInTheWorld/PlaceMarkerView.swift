//
//  PlaceMarkerView.swift
//  WhereInTheWorld
//
//  Created by Max Zvyagin on 2/11/20.
//  Copyright © 2020 Max Zvyagin. All rights reserved.
//

import UIKit
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation?{
        willSet{
            clusteringIdentifier = "Place"
            displayPriority = .defaultLow
            markerTintColor = .systemGreen
            glyphImage = UIImage(systemName:"pin.fill")
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
