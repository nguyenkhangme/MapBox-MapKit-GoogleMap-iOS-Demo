//
//  MainModel.swift
//  mapApp
//
//  Created by user on 5/21/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation
import CoreLocation

protocol ParseDataFromSearch: class {
    func parseData(data: [PlaceMarkForAllMap])
}
struct PlaceMarkForAllMap{
    static var shared = [PlaceMarkForAllMap]()
    var Name: String?
    var placeName: String?
    var longitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
}
