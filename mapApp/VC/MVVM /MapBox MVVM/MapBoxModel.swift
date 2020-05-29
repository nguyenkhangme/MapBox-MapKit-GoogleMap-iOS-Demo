//
//  MapBoxStruct.swift
//  mapApp
//
//  Created by user on 5/21/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation

import CoreLocation

struct MapBoxPlaceMark: MapsModelAccess {
       
       var placeName: [String] = []
       var Name: [String] = []
       var coordinates: [[Double]] = []
       
       private enum CodingKeys: String, CodingKey {
           case placeName = "place_name"
           case Name = "text"
           case coordinates
       }
       
   }


struct MapBoxPlaceMarkService: Decodable {
       
       var type: String?
       var query: [String]?
       var features: [feature]?
       
      
       
       struct feature: Decodable {
           var id: String
           var type: String
           var place_type: [String]
           var relevance: Double
           var properties: property
           
           struct property: Decodable {
               var markerColor: String?
               var markerSize: String?
               var markerSymbol: String?
               
                private enum CodingKeys: String, CodingKey {
                   case markerColor = "marker-color"
                   case markerSize = "marker-size"
                   case markerSymbol = "marker-symbol"
               }
           }
           
           var text: String
           var place_name: String
           var matching_text: String?
           var matching_place_name: String?
           var center: [Double]
           var geometry: Geometry
           
           struct Geometry: Decodable {
               var type: String
               var coordinates: [Double]
               var interpolated: Bool?
               var omitted: Bool?
           }
           
           var address: String?
           var context: [Context]?
           
           
           struct Context: Decodable {
               var id: String?
               var short_code: String?
               var wikidata: String?
               var text: String?
           }
           
          
           
           
       }
       
        var attribution: String?
   }

   extension MapBoxPlaceMark {
       init(from service: MapBoxPlaceMarkService) {
           
           guard let Features = service.features else {
               return
           }
           for Feature in Features {
               placeName.append(Feature.place_name)
               Name.append(Feature.text)

               let Geometry = Feature.geometry
               coordinates.append(Geometry.coordinates)

           }
       }
}
