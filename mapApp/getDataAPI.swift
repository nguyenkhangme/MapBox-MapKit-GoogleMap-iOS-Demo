//
//  getDataAPI.swift
//  MapboxCoreNavigation
//
//  Created by Vinova on 4/17/20.
//

import Foundation


struct FetchData {
    func loadData(query: String) {
        guard let url = URL(string:"https://api.mapbox.com/geocoding/v5/mapbox.places/" + query + ".json?access_token=pk.eyJ1IjoiZHVuY2Fubmd1eWVuIiwiYSI6ImNrOTJsY3FmaTA5cHkzbG1qeW45ZGFibHMifQ.w8C6P04eSOR7CDLhRXBz6g") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let data = data
//            if let string = String(data: data, encoding: .utf8) {
//                DispatchQueue.main.async {
//
//                }
//                    //print(\(string))
//            }
            
            
        }
        task.resume()
    }

}
