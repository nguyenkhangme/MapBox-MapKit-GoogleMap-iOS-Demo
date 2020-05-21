//
//  MapBoxViewModel.swift
//  mapApp
//
//  Created by user on 5/18/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//


//This file for practice MVVM Pattern

import UIKit

import MapboxGeocoder

import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

import CoreLocation

import PromiseKit

struct MapBoxPlaceMark{
    var Name: String
    
    var placeName: String
    
    var longitude: CLLocationDegrees
    
    var latitude: CLLocationDegrees
    
    
}

struct MapBoxModel {
    
  var placeMark = [PlaceMarkForAllMap]()
    
}

extension MapBoxModel: ModelAccess{
    func fetchData(query: String) {
        print("qwe")
    }
    
    func getPlaceMark() -> [PlaceMarkForAllMap] {
        return placeMark
    }
}
