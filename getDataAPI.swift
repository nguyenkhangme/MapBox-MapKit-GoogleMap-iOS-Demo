//
//  getDataAPI.swift
//  MapboxCoreNavigation
//
//  Created by Vinova on 4/17/20.
//

import Foundation

//https://www.hackingwithswift.com/books/ios-swiftui/sending-and-receiving-codable-data-with-urlsession-and-swiftui

struct FetchData {
    func loadData(query: String) {
        guard let url = URL(string:"https://api.mapbox.com/geocoding/v5/mapbox.places/" + query + ".json?access_token=YOUR_MAPBOX_ACCESS_TOKEN") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the result of that networking task.
        }.resume()
    }
}
