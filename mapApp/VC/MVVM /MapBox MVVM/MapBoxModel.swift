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

class MapBoxModel {
    
    var placeMark = [PlaceMarkForAllMap]()
    
    func setPlaceMark(mapBoxPlaceMark: MapBoxPlaceMark) -> [PlaceMarkForAllMap]{
        var temp = PlaceMarkForAllMap()
        for i in mapBoxPlaceMark.Name.indices {
            
            temp.Name = mapBoxPlaceMark.Name[i]
            temp.placeName = mapBoxPlaceMark.placeName[i]
            temp.latitude = mapBoxPlaceMark.coordinates[i][1]
            temp.latitude = mapBoxPlaceMark.coordinates[i][0]
            placeMark.append(temp)
        }
        return placeMark
        
        
    }
    
    func loadPlaceMark(query: String, latitude: Double, longitude: Double) -> Promise<MapBoxPlaceMarkService>? {
           
            
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
                return try JSONDecoder().decode(MapBoxPlaceMarkService.self, from: $0.data)
            }
        
        promise.catch{ error in
            print(error)
                    
        }
        return promise
                
    }
    
    
   
    
}

extension MapBoxModel: ModelAccess{
    
    func fetchData(query: String, latitude: Double, longitude: Double) -> [PlaceMarkForAllMap]?{
        var placeMarkss = MapBoxPlaceMark()
        let promise =
            firstly(){
                return (loadPlaceMark(query: query, latitude: latitude, longitude: longitude)!)
            }
            .done() { placeMarkStores in
                   
                placeMarkss = MapBoxPlaceMark(from: placeMarkStores)
            }
               
        promise.catch(){ error in
            print(error)
        }
            
        var placeMarkx = [PlaceMarkForAllMap]()
        placeMarkx = setPlaceMark(mapBoxPlaceMark: placeMarkss)
        return placeMarkx
    }
    
    
    func getPlaceMark() -> [PlaceMarkForAllMap] {
        return placeMark
    }
}
