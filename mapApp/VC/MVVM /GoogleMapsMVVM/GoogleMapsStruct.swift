//
//  GoogleMapsStruct.swift
//  mapApp
//
//  Created by user on 5/25/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation

struct GoogleMapsPlaceMarkService: Decodable {
    var results: [result]?
    struct result: Decodable {
        var geometry: geometry?
        
        struct geometry: Decodable {
            var location: locations?
            
            struct locations: Decodable{
                var lat: Double?
                var lng: Double?
            }
        }
        
        var name: String?
        var formatted_address: String?
        
    }
}

struct GoogleMapsPlaceMark {
    
    static var shared = [GoogleMapsPlaceMark]()
    var lat: [Double] = []
    var lng: [Double] = []
    var name: [String] = []
    var formatted_address: [String] = []
    
}

extension GoogleMapsPlaceMark {
    
    init(from service: GoogleMapsPlaceMarkService) {
        
        //self.init()
        
        guard let Results = service.results else {
            return
        }
        
        for Result in Results {
            //var temp = GoogleMapsPlaceMark()
            name.append(Result.name ?? "")
            formatted_address.append(Result.formatted_address ?? "")
            
            guard let Geometry = Result.geometry  else {
                return
            }
            
            
                
                guard let Location = Geometry.location  else {
                    return
                }
                
                    lng.append(Location.lng ?? 0)
                    lat.append(Location.lat ?? 0)
                
                
            
            
//            GoogleMapsPlaceMark.shared.append(temp)
        }
        
    }
}
