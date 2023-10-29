//
//  HeroAnnotation.swift
//  DragonBallAvanzado
//
//  Created by Natalia Hernandez on 29/10/23.
//

import UIKit
import MapKit

class HeroAnnotation: NSObject, MKAnnotation{
    var title: String?
    var photo: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String? = nil, photo: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
