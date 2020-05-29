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



class MapBoxQueryService {
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    typealias QueryResult = ([PlaceMarkForAllMap]) -> Void
    
    weak var parseDataDelegate: ParseDataFromSearch? = nil
    
    func setPlaceMark(mapBoxPlaceMark: MapBoxPlaceMark) -> [PlaceMarkForAllMap]{
        
        PlaceMarkForAllMap.shared.removeAll()
        var temp = PlaceMarkForAllMap()
        //print("mapBoxPlaceMark: \(mapBoxPlaceMark.Name.count)")
        for i in mapBoxPlaceMark.Names.indices {
            
            temp.Name = mapBoxPlaceMark.Names[i]
            temp.placeName = mapBoxPlaceMark.placeNames[i]
            temp.latitude = mapBoxPlaceMark.coordinates[i][1]
            temp.longitude = mapBoxPlaceMark.coordinates[i][0]
            PlaceMarkForAllMap.shared.append(temp)
        }
        return PlaceMarkForAllMap.shared
        
        
    }
    
    func loadPlaceMark(query: String, latitude: Double, longitude: Double) -> Promise<MapBoxPlaceMarkService>? {
           
            
        guard let urlString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return nil
                
            }
            
        var urlComponents = URLComponents(string: "https://api.mapbox.com/geocoding/v5/mapbox.places/" + urlString + ".json")
        urlComponents?.query = "proximity="+String(longitude)+","+String(latitude)+"&access_token=pk.eyJ1IjoiZHVuY2Fubmd1eWVuIiwiYSI6ImNrOTJsY3FmaTA5cHkzbG1qeW45ZGFibHMifQ.w8C6P04eSOR7CDLhRXBz6g"
//        let queries = ["proximity" : "\(longitude),\(latitude)",
//            "access_token": "pk.eyJ1IjoiZHVuY2Fubmd1eWVuIiwiYSI6ImNrOTJsY3FmaTA5cHkzbG1qeW45ZGFibHMifQ.w8C6P04eSOR7CDLhRXBz6g"]
//
//        for (key,value) in queries {
//            let temp = URLQueryItem(name: key,value: value)
//            urlComponents?.queryItems?.append(temp)
//        }
//
        print(urlComponents ?? "dd")
        
        guard let url = urlComponents?.url else {
          print("Invalid URL")
          return nil
        }
            
//        guard let url = URL(string:"https://api.mapbox.com/geocoding/v5/mapbox.places/" + urlString + ".json?proximity="+String(longitude)+","+String(latitude)+"&access_token=pk.eyJ1IjoiZHVuY2Fubmd1eWVuIiwiYSI6ImNrOTJsY3FmaTA5cHkzbG1qeW45ZGFibHMifQ.w8C6P04eSOR7CDLhRXBz6g")
//        else {
//                print("Invalid URL")
//                return nil
//            }
            
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
    
    //MARK: (Yeu cau cua anh Rio) ReWrite, use closure instead of delegate
    
    func fetchData1(query: String, latitude: Double, longitude: Double, completion: @escaping QueryResult) -> [PlaceMarkForAllMap]?{
        
        print("fetch Data MapBox Model\n---")
        var placeMarks = MapBoxPlaceMark()
        //var mapBoxPlaceMarkService = MapBoxPlaceMarkService()
        let promise =
            firstly{
                loadPlaceMark(query: query, latitude: latitude, longitude: longitude)!
            }
            .done() { placeMarkStores in
                   
                placeMarks = MapBoxPlaceMark(from: placeMarkStores)
                //print("placeMarks fetchData: \(placeMarks.Name.count)")
                PlaceMarkForAllMap.shared = self.setPlaceMark(mapBoxPlaceMark: placeMarks)
                
                //MARK: use closures instead of delegate
                DispatchQueue.main.async {
                           completion(PlaceMarkForAllMap.shared)
                }
               // self.parseDataDelegate?.parseData(data: PlaceMarkForAllMap.shared)
                
            }
               
        promise.catch(){ error in
            print(error)
        }
        
        //placeMarks = MapBoxPlaceMark(from: mapBoxPlaceMarkService)
        
       // print("fetchData: Mapbox: placeMarkStores: \(String(describing: mapBoxPlaceMarkService.features?[0].text))")
        //var placeMarkx = [PlaceMarkForAllMap]()
        
       // print("MapBoxModel.placeMark: \(PlaceMarkForAllMap.shared)\n---")
        return PlaceMarkForAllMap.shared
    }
   
    
}

extension MapBoxQueryService: QueryServiceAccess{
    
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
                //print("placeMarks fetchData: \(placeMarks.Name.count)")
                PlaceMarkForAllMap.shared = self.setPlaceMark(mapBoxPlaceMark: placeMarks)
                
                self.parseDataDelegate?.parseData(data: PlaceMarkForAllMap.shared)
                //mapBoxPlaceMarkService = placeMarkStores
            }
               
        promise.catch(){ error in
            print(error)
        }
        
        //placeMarks = MapBoxPlaceMark(from: mapBoxPlaceMarkService)
        
       // print("fetchData: Mapbox: placeMarkStores: \(String(describing: mapBoxPlaceMarkService.features?[0].text))")
        //var placeMarkx = [PlaceMarkForAllMap]()
        
       // print("MapBoxModel.placeMark: \(PlaceMarkForAllMap.shared)\n---")
        return PlaceMarkForAllMap.shared
    }
    
    
    func getPlaceMark() -> [PlaceMarkForAllMap] {
        return PlaceMarkForAllMap.shared
    }
}
