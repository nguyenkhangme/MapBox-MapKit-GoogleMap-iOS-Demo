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
    
    static var placeMark = [PlaceMarkForAllMap]()
    
    weak var parseDataDelegate: ParseDataFromSearch? = nil
    
    func setPlaceMark(mapBoxPlaceMark: MapBoxPlaceMark) -> [PlaceMarkForAllMap]{
        
        MapBoxModel.placeMark.removeAll()
        var temp = PlaceMarkForAllMap()
        print("mapBoxPlaceMark: \(mapBoxPlaceMark.Name.count)")
        for i in mapBoxPlaceMark.Name.indices {
            
            temp.Name = mapBoxPlaceMark.Name[i]
            temp.placeName = mapBoxPlaceMark.placeName[i]
            temp.latitude = mapBoxPlaceMark.coordinates[i][1]
            temp.latitude = mapBoxPlaceMark.coordinates[i][0]
            MapBoxModel.placeMark.append(temp)
        }
        return MapBoxModel.placeMark
        
        
    }
    
    func loadPlaceMark(query: String, latitude: Double, longitude: Double) -> Promise<MapBoxPlaceMarkService>? {
           
            
        guard let urlString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return nil
                
            }
            
        guard let url = URL(string:"https://api.mapbox.com/geocoding/v5/mapbox.places/" + urlString + ".json?proximity="+String(longitude)+","+String(latitude)+"&access_token=pk.eyJ1IjoiZHVuY2Fubmd1eWVuIiwiYSI6ImNrOTJsY3FmaTA5cHkzbG1qeW45ZGFibHMifQ.w8C6P04eSOR7CDLhRXBz6g")
        else {
                print("Invalid URL")
                return nil
            }
            
        //print("url:\(url)")
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
        //print("Promise PlaceMarkService: \(promise.tap(){x in x.features})")
        return promise
                
    }
    
    
   
    
}

extension MapBoxModel: ModelAccess{
    
    func fetchData(query: String, latitude: Double, longitude: Double) -> [PlaceMarkForAllMap]?{
        
        print("fetch Data MapBox Model\n---")
        var placeMarks = MapBoxPlaceMark()
        //var mapBoxPlaceMarkService = MapBoxPlaceMarkService()
        let promise =
            firstly{
                loadPlaceMark(query: query, latitude: latitude, longitude: longitude)!
            }
            .done() { placeMarkStores in
                   
                placeMarks = MapBoxPlaceMark(from: placeMarkStores)
                print("placeMarks fetchData: \(placeMarks.Name.count)")
                MapBoxModel.placeMark = self.setPlaceMark(mapBoxPlaceMark: placeMarks)
                
                self.parseDataDelegate?.parseData(data: MapBoxModel.placeMark)
                //mapBoxPlaceMarkService = placeMarkStores
            }
               
        promise.catch(){ error in
            print(error)
        }
        
        //placeMarks = MapBoxPlaceMark(from: mapBoxPlaceMarkService)
        
       // print("fetchData: Mapbox: placeMarkStores: \(String(describing: mapBoxPlaceMarkService.features?[0].text))")
        //var placeMarkx = [PlaceMarkForAllMap]()
        
        print("MapBoxModel.placeMark: \(MapBoxModel.placeMark)\n---")
        return MapBoxModel.placeMark
    }
    
    
    func getPlaceMark() -> [PlaceMarkForAllMap] {
        return MapBoxModel.placeMark
    }
}
