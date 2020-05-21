//
//  MainPresenter.swift
//  mapApp
//
//  Created by user on 5/18/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation

protocol PresenterView: class {
    func updateType(type:String)
    func configureBarButton()
    func configureMapBox()
}

class MainPresenter {
    weak var view: PresenterView?
    // Pass something that conforms to PresenterView
    init(with view: PresenterView) {
        self.view = view
    }
    
    var type = String()
    func updateType(whatMap: String){
        
        if whatMap == "Google" {
            type = "Google"
        }else if whatMap == "MapBox"{
            type = "MapBox"
            
        }else if whatMap == "MapKit"{
            type = "MapKit"
            
        }
        
        self.view?.updateType(type: type)
    }

    func configureMapBox(type: String){
        if(type == "MapBox"){
            self.view?.configureMapBox()
        }
    }
}

