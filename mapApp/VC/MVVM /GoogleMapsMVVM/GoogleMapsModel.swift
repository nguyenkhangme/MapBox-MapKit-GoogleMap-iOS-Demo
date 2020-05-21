//
//  GoogleMapsViewModel.swift
//  mapApp
//
//  Created by user on 5/18/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation

import CoreLocation

struct GoogleMapsPlaceMark {
    var Name: String
    
    var placeName: String
    
    var longitude: CLLocationDegrees
    
    var latitude: CLLocationDegrees
    
    
}

class GoogleMapsModel{
   var placeMark = [PlaceMarkForAllMap]()
}

extension GoogleMapsModel: ModelAccess{
    func fetchData(query: String) {
        print("")
    }
    
    func getPlaceMark() -> [PlaceMarkForAllMap] {
    
        return placeMark
    }
    
    
}

