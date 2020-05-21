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
    

   
        
    func loadPlaceMark(query: String, latitude: Double, longitude: Double) -> Promise<PlaceMarkService>? {
           
            
        guard let urlString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return nil
                
            }
            
        guard let url = URL(string:"https://api.mapbox.com/geocoding/v5/mapbox.places/" + urlString + ".json?proximity="+String(longitude)+","+String(latitude)+"&access_token=pk.eyJ1IjoiZHVuY2Fubmd1eWVuIiwiYSI6ImNrOTJsY3FmaTA5cHkzbG1qeW45ZGFibHMifQ.w8C6P04eSOR7CDLhRXBz6g") else {
                print("Invalid URL")
                return nil
            }
            
        let request = URLRequest(url: url)
        
            
        let promise =
            firstly() {
                
                return URLSession.shared.dataTask(.promise, with:request)
                    
            }.compactMap {
                return try JSONDecoder().decode(PlaceMarkService.self, from: $0.data)
            }
        
        promise.catch{ error in
            print(error)
                    
        }
        return promise
                
    }
    
}

extension MapBoxModel: ModelAccess{
    
     func fetchData(query: String, latitude: Double, longitude: Double) -> [PlaceMarkForAllMap]?{
           var placeMarkss = PlaceMark()
           let promise =
               firstly(){
                           
                return (loadPlaceMark(query: query, latitude: latitude, longitude: longitude)!)
                      
               }
               .done() { placeMarkStores in
                   
                   placeMarkss = PlaceMark(from: placeMarkStores)
                   
               }
               
           promise.catch(){ error in
               print(error)
           }
               
           return placeMarkss
       }
    
    
    func getPlaceMark() -> [PlaceMarkForAllMap] {
        return placeMark
    }
}
