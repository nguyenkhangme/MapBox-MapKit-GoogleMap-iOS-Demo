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

struct MapBoxViewModel {
    private var fetchData = FetchData()
    init(model: FetchData){
        self.fetchData = model
    }
    var placeMark = PlaceMark()
    
    mutating func search(query: String, coordinate: CLLocationCoordinate2D) {
        
        if let placeMark = fetchData.fetchData(query: query, coordinate: coordinate){
            self.placeMark = placeMark
        } else {
            return
        }
        
    }
     
    
    var coordinates: [[CLLocationDegrees]] {
        return [[CLLocationDegrees]](placeMark.coordinates)
    }
    
  
    
    var title: [String] {
        return placeMark.Name
    }
    
    var subtitle: [String] {
        return placeMark.placeName
    }
    
}
