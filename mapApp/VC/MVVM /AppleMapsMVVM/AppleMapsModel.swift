//
//  AppleMapsModel.swift
//  mapApp
//
//  Created by user on 6/2/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation
import MapKit

class AppleMapsPlaceMark: NSObject, MKAnnotation,MapsModelAccess {
    
    //MapsModelAccess
    
    var Name: String?
    
    var placeName: String?
    
    var longitude: CLLocationDegrees?
    
    var latitude: CLLocationDegrees?
    
    //
    
    let title: String?
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D

    init(
      title: String?,
      locationName: String?,
      discipline: String?,
      coordinate: CLLocationCoordinate2D
    ) {
      self.title = title
      self.locationName = locationName
      self.discipline = discipline
      self.coordinate = coordinate

      super.init()
    }

    var subtitle: String? {
      return locationName
    }
    
    
}
