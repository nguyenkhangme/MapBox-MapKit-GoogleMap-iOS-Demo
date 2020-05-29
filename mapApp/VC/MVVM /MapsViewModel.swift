//
//  MainViewModel.swift
//  mapApp
//
//  Created by user on 5/29/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol MapsModelAccess {
    var Name: String? { get set }
    var placeName: String? { get set }
    var longitude: CLLocationDegrees? { get set }
    var latitude: CLLocationDegrees? { get set }

}


struct MapsModelFactory{
    func getMapsModel(typeOfMapsModel: TypeOfMaps) -> MapsModelAccess?{
    
        switch typeOfMapsModel {
        case .MapBox:
            return MapBoxPlaceMark()
        case .AppleMaps:
            return nil
        case .Google:
            return GoogleMapsPlaceMark()
        }
        
    }
}


struct MapsViewModel {
    
    var Name: String?
    var placeName: String?
    var longitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    
    
    private var _mapsModelAccess: MapsModelAccess?
    var mapsModelFactory = MapsModelFactory()
    
    
    var userLocation = CLLocationCoordinate2D()
   
    
    //MARK:Sketch
    //Assign type -> Return new instance of type we need. It work well with query service, is it true for View Model?
    //We use this way in Query Service, so I will try another way in View Model, which we can use init of VM like:
    //models.map({return MapsViewModel(mapsModel: $0) })
    
//    init(mapsModelAccess: MapsModelAccess){
//        self._mapsModelAccess = mapsModelAccess
//        if _mapsModelAccess == nil {
//            print("ERROR: Not support yet")
//        }
//        
//    
//        self.Name = mapsModelAccess.Name
//        self.placeName = mapsModelAccess.placeName
//        self.longitude = mapsModelAccess.longitude
//        self.latitude = mapsModelAccess.latitude
//    }
    
    mutating func setMapsModel(mapsModelAccess: MapsModelAccess){
        self._mapsModelAccess = mapsModelAccess
        if _mapsModelAccess == nil {
            print("ERROR: Not support yet")
        }
        
        self.Name = mapsModelAccess.Name
        self.placeName = mapsModelAccess.placeName
        self.longitude = mapsModelAccess.longitude
        self.latitude = mapsModelAccess.latitude
    }
    
    //Tam thoi
    var placeMark = PlaceMarkForAllMap()
    
}
