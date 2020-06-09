//
//  GoogleMapsViewModel.swift
//  mapApp
//
//  Created by user on 5/18/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

//https://developers.google.com/places/web-service/search?hl=vi
//Request: https://developers.google.com/places/web-service/search?hl=vi#TextSearchRequests
//Responses
import Foundation

import CoreLocation

import PromiseKit

class GoogleMapsQueryService{
    
    weak var parseDataDelegate: ParseDataFromSearch? = nil
    
    
    func loadPlaceMark(query: String, latitude: Double, longitude: Double) -> Promise<GoogleMapsPlaceMarkService>? {
           
            
        guard let urlString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
            {
                return nil
                
            }
          
        //Uncomment this code below to search around user Location but I do not know how to get USer Location in google map yet.
//        guard let url = URL(string:"https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + urlString + "&location="+String(longitude)+","+String(latitude)+"&radius=10000&key=AIzaSyCvuaYDzCqq7GvOvey6pZSn4bhY92iq7E8")
        
        //https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Museum%20of%20Contemporary%20Art%20Australia&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key=
        
        
        guard let url = URL(string:"https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=" + urlString + "&inputtype=textquery&fields=place_id,formatted_address,name,geometry/location&key=AIzaSyDzZ2ixVoy_vDGRrc52Axw45YifTu0qvQQ")
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
                
                return try JSONDecoder().decode(GoogleMapsPlaceMarkService.self, from: $0.data)
            }
        print("OK getData")
        
        promise.catch{ error in
            print(error)
                    
        }
        //print("Promise PlaceMarkService: \(promise.tap(){x in x.features})")
        return promise
                
    }
    
    func setPlaceMark(GoogleMapsPlaceMark: GoogleMapsPlaceMark) -> [PlaceMarkForAllMap]{
        
        PlaceMarkForAllMap.shared.removeAll()
        var temp = PlaceMarkForAllMap()
        //print("mapBoxPlaceMark: \(mapBoxPlaceMark.Name.count)")
        for i in GoogleMapsPlaceMark.name.indices {
            
            temp.Name = GoogleMapsPlaceMark.name[i]
            temp.placeName = GoogleMapsPlaceMark.formatted_address[i]
            temp.latitude = GoogleMapsPlaceMark.lat[i]
            temp.longitude = GoogleMapsPlaceMark.lng[i]
           // temp.longitude = GoogleMapsPlaceMark.location[i][1].value
            //temp.latitude = mapBoxPlaceMark.coordinates[i][1]
            //temp.longitude = mapBoxPlaceMark.coordinates[i][0]
            PlaceMarkForAllMap.shared.append(temp)
        }
        return PlaceMarkForAllMap.shared
        
        
    }
    
    
    
}

extension GoogleMapsQueryService: QueryServiceAccess{
   
    func fetchData(query: String, latitude: Double, longitude: Double) -> [PlaceMarkForAllMap]?{
           
           print("fetch Data GoogleMaps Model\n---")
           var placeMarks = GoogleMapsPlaceMark()
           //var mapBoxPlaceMarkService = MapBoxPlaceMarkService()
           let promise =
               firstly{
                   loadPlaceMark(query: query, latitude: latitude, longitude: longitude)!
               }
               .done() { placeMarkStores in
                      
                   placeMarks = GoogleMapsPlaceMark(from: placeMarkStores)
                   //print("placeMarks fetchData: \(placeMarks.Name.count)")
                PlaceMarkForAllMap.shared = self.setPlaceMark(GoogleMapsPlaceMark: placeMarks)
                   
                   self.parseDataDelegate?.parseData(data: PlaceMarkForAllMap.shared)
                   //mapBoxPlaceMarkService = placeMarkStores
               }
                  
           promise.catch(){ error in
               print(error)
           }
           
          
           
           return PlaceMarkForAllMap.shared
       }
    
    func getPlaceMark() -> [PlaceMarkForAllMap] {
    
        return PlaceMarkForAllMap.shared
    }
    
    func fetchData1(query: String, latitude: Double, longitude: Double, completion: @escaping QueryResult) -> [PlaceMarkForAllMap]? {
          return nil
       }
    
}

