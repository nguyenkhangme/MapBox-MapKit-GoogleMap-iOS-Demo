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
    
    var placeName: String = ""
    var matchingPlaceName: String = ""
    var coordinates: [Double] = []
    
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
        var place_name: String
        var matching_text: String
        var matching_place_name: String
        var center: [Double]
        var geometry:[Geometry]
        var address: String
        var context: [Context]
        
        
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
        
        struct Geometry: Decodable {
            var type: String
            var coordinates: [Double]
            var interpolated: Bool
            var omitted: Bool
        }
        
        struct Context: Decodable {
            var id: String
            var short_code: String
            var wikidata: String
            var text: String
        }
        
       
        
        
    }
}

extension PlaceMark {
    init(from service: PlaceMarkService) {
        for Feature in service.features {
            placeName = Feature.place_name
            matchingPlaceName = Feature.matching_place_name
            for Geometry in Feature.geometry {
                coordinates = Geometry.coordinates
            }
        }
    }
}
