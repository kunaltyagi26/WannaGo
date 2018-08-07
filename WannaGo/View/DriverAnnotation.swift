//
//  DriverAnnotation.swift
//  WannaGo
//
//  Created by Kunal Tyagi on 07/08/18.
//  Copyright © 2018 Kunal Tyagi. All rights reserved.
//

import Foundation
import GoogleMaps

class DriverAnnotation: GMSMarker {
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var key: String
    
    init(coordinate: CLLocationCoordinate2D, withKey key: String) {
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
    
    func update(annotationPosition annotation: DriverAnnotation, withCoordinate coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }
}
