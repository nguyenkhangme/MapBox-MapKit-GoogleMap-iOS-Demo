//
//  MainViewModel.swift
//  mapApp
//
//  Created by user on 5/29/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation

protocol MapsModelAccess {
    
}


struct MapsViewModelFactory{
    func getMapsViewModel(typeOfMapsViewModel: TypeOfMaps) -> MapsModelAccess?{
    
        switch typeOfMapsViewModel {
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
    
}
