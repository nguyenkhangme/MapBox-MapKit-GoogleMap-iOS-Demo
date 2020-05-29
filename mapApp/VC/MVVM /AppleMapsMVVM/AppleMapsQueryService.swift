//
//  AppleMapsViewModel.swift
//  mapApp
//
//  Created by user on 5/18/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation

import CoreLocation

struct AppleMapsPlaceMark{
    
    var Name: String
    
    var placeName: String
    
    var longitude: Double
    
    var latitude: Double
    
    
}

class AppleMapsQueryService {
    
    weak var parseDataDelegate: ParseDataFromSearch? = nil
    
    var appleMapsPlaceMarks: [AppleMapsPlaceMark] = []
    
    var placeMark = [PlaceMarkForAllMap]()
}

extension AppleMapsQueryService:QueryServiceAccess{
    
   
  
    func fetchData(query: String, latitude: Double, longitude: Double) -> [PlaceMarkForAllMap]? {
        print("")
        return nil
    }
    
    func getPlaceMark() -> [PlaceMarkForAllMap] {
        return placeMark
    }
    
    func fetchData1(query: String, latitude: Double, longitude: Double, completion: @escaping QueryResult) -> [PlaceMarkForAllMap]? {
        return nil
    }

    
}
