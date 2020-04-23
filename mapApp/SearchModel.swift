//
//  SearchModel.swift
//  mapApp
//
//  Created by Vinova on 4/23/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//
import CoreLocation
import Foundation

struct PlaceMark {
    
    var placeName: String
    var matchingPlaceName: String
    var coordinates: [CLLocationCoordinate2D]
    
    private enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case matchingPlaceName = "matching_place_name"
        
    }
}

struct PlaceMarkService: Decodable {
    
    var type: String
    var query: [String]
    var features: [feature]
    
    struct feature: Decodable {
        var id: String
        var type: String
        var place_type: [String]
        var relevance: Int
        var properties: [property]
        var text: String
        
        struct property: Decodable {
            var markerColor: String
            var markerSize: String
            var markerSymbol: String
            
             private enum CodingKeys: String, CodingKey {
                case markerColor = "marker-color"
                case markerSize = "marker-size"
                case markerSymbol = "marker-symbol"
            }
        }
        
        
    }
}
