//
//  getDataAPI.swift
//  MapboxCoreNavigation
//
//  Created by Vinova on 4/17/20.
//

import Foundation

struct abcdef {
    func loadData(query: String) {
        guard let url = URL(string:"https://api.mapbox.com/geocoding/v5/mapbox.places/" + query + ".json?access_token=YOUR_MAPBOX_ACCESS_TOKEN") else {
            print("Invalid URL")
            return
        }
    }
}
