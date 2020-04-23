//
//  MapModule.swift
//  mapApp
//
//  Created by Vinova on 4/17/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation

import Mapbox

import MapboxGeocoder

import CoreLocation

struct Map: Codable {
    
    var latitude: CLLocationDegrees = 0
    
    var longtitude: CLLocationDegrees = 0
    
    var title = ""
    
    var subtitle = ""
    
    //var test: CLLocationCoordinate2D
    //var coordinate = ["latitude": CLLocationDegrees(0), "longtitude": CLLocationDegrees(0)]
}

