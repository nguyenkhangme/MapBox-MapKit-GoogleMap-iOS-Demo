//
//  SearchModel.swift
//  mapApp
//
//  Created by Vinova on 4/23/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//
import CoreLocation
import Foundation


struct FetchData {
    
//    var placeMark = PlaceMark()
//    var placeMarkStores = PlaceMarkService()
    
    static let shared = FetchData()
    
    func loadData(query: String) {
        
        guard let urlString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else
        {
            return
            
        }
        guard let url = URL(string:"https://api.mapbox.com/geocoding/v5/mapbox.places/" + urlString + ".json?country=CA&access_token=pk.eyJ1IjoiZHVuY2Fubmd1eWVuIiwiYSI6ImNrOTJsY3FmaTA5cHkzbG1qeW45ZGFibHMifQ.w8C6P04eSOR7CDLhRXBz6g") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
//            let data = data
//            if let string = String(data: data, encoding: .utf8) {
//                DispatchQueue.main.async {
//
//                }
//                    //print(\(string))
//            }
                
                guard let json = data else {
                    print("Unexpected error URLSessionDataTask: \(String(describing: error)).")
                    return
                    
            }
                
//                let placeMarkStores = try decoder.decode([PlaceMarkService].self, from: json)
//
//                let placeMarks = placeMarkStores.map { PlaceMark(from: $0) }
//
//                for placeMark in placeMarks {
//                    print("\(placeMark.placename)\n\(placeMark.matchingPlaceName)\n")
//                }
                
                let decoder = JSONDecoder()
                do {
                    let placeMarkStores = try decoder.decode(PlaceMarkService.self, from: json)
                    let placeMarks = PlaceMark(from: placeMarkStores)
                    
                    //for placeMark in placeMarks {
                    
                    
                    for placeMarkCount in placeMarks.Name.indices {
                        //print("\(placeMarkName)\n")
                        print("\(placeMarks.Name[placeMarkCount])\n")
                        print("\(placeMarks.placeName[placeMarkCount])\n\n")
                    }
                    
//                    for placeMarkName in placeMarks.Name {
//                        print("\(placeMarkName)\n")
//                    }
//                    for placeMarkPlaceName in placeMarks.placeName {
//                        print("\(placeMarkPlaceName)\n\n")
//                    }
                    //}
                }catch {
                    print("Unexpected error: \(error).")
                }
                    
          
            
            
            
        }
        task.resume()
    }

}

struct test {
    
    static let shared = test()
    let json = """
{
        "type": "FeatureCollection",
        "query": [
            "825",
            "s",
            "milwaukee",
            "ave",
            "deerfield",
            "il",
            "60015"
        ],
        "features": [{
                "id": "address.4356035406756260",
                "type": "Feature",
                "place_type": [
                    "address"
                ],
                "relevance": 1,
                "properties": {},
                "text": "Milwaukee Ave",
                "place_name": "825 Milwaukee Ave, Deerfield, Illinois 60015, United States",
                "matching_text": "South Milwaukee Avenue",
                "matching_place_name": "825 South Milwaukee Avenue, Deerfield, Illinois 60015, United States",
                "center": [
                    -87.921434,
                    42.166602
                ],
                "geometry": {
                    "type": "Point",
                    "coordinates": [
                        -87.921434,
                        42.166602
                    ],
                    "interpolated": true,
                    "omitted": true
                },
                "address": "825",
                "context": [{
                        "id": "neighborhood.287187",
                        "text": "Lake Cook Road"
                    },
                    {
                        "id": "postcode.13903677306297990",
                        "text": "60015"
                    },
                    {
                        "id": "place.5958304312090910",
                        "wikidata": "Q287895",
                        "text": "Deerfield"
                    },
                    {
                        "id": "region.3290978600358810",
                        "short_code": "US-IL",
                        "wikidata": "Q1204",
                        "text": "Illinois"
                    },
                    {
                        "id": "country.9053006287256050",
                        "short_code": "us",
                        "wikidata": "Q30",
                        "text": "United States"
                    }
                ]
            },
            {
                "id": "address.7464624790403620",
                "type": "Feature",
                "place_type": [
                    "address"
                ],
                "relevance": 0.5,
                "properties": {},
                "text": "Milwaukee Ave",
                "place_name": "825 Milwaukee Ave, Wheeling, Illinois 60090, United States",
                "matching_text": "South Milwaukee Avenue",
                "matching_place_name": "825 South Milwaukee Avenue, Wheeling, Illinois 60090, United States",
                "center": [
                    -87.910299,
                    42.144504
                ],
                "geometry": {
                    "type": "Point",
                    "coordinates": [
                        -87.910299,
                        42.144504
                    ],
                    "interpolated": true
                },
                "address": "825",
                "context": [{
                        "id": "neighborhood.287187",
                        "text": "Lake Cook Road"
                    },
                    {
                        "id": "postcode.9418633295906190",
                        "text": "60090"
                    },
                    {
                        "id": "place.9902190947082220",
                        "wikidata": "Q935043",
                        "text": "Wheeling"
                    },
                    {
                        "id": "region.3290978600358810",
                        "short_code": "US-IL",
                        "wikidata": "Q1204",
                        "text": "Illinois"
                    },
                    {
                        "id": "country.9053006287256050",
                        "short_code": "us",
                        "wikidata": "Q30",
                        "text": "United States"
                    }
                ]
            },
            {
                "id": "address.6472754353404224",
                "type": "Feature",
                "place_type": [
                    "address"
                ],
                "relevance": 0.5,
                "properties": {},
                "text": "Milwaukee Avenue",
                "place_name": "825 Milwaukee Avenue, Glenview, Illinois 60025, United States",
                "matching_text": "South Milwaukee Avenue",
                "matching_place_name": "825 South Milwaukee Avenue, Glenview, Illinois 60025, United States",
                "center": [
                    -87.852677,
                    42.071152
                ],
                "geometry": {
                    "type": "Point",
                    "coordinates": [
                        -87.852677,
                        42.071152
                    ]
                },
                "address": "825",
                "context": [{
                        "id": "neighborhood.275266",
                        "text": "Northfield Woods"
                    },
                    {
                        "id": "postcode.3787740186211610",
                        "text": "60025"
                    },
                    {
                        "id": "place.10211845459386970",
                        "wikidata": null,
                        "text": "Glenview"
                    },
                    {
                        "id": "region.3290978600358810",
                        "short_code": "US-IL",
                        "wikidata": "Q1204",
                        "text": "Illinois"
                    },
                    {
                        "id": "country.9053006287256050",
                        "short_code": "us",
                        "wikidata": "Q30",
                        "text": "United States"
                    }
                ]
            },
            {
                "id": "address.1225436500189372",
                "type": "Feature",
                "place_type": [
                    "address"
                ],
                "relevance": 0.5,
                "properties": {},
                "text": "Milwaukee Ave",
                "place_name": "825 Milwaukee Ave, Buffalo Grove, Illinois 60089, United States",
                "matching_text": "South Milwaukee Avenue",
                "matching_place_name": "825 South Milwaukee Avenue, Buffalo Grove, Illinois 60089, United States",
                "center": [
                    -87.917484,
                    42.158084
                ],
                "geometry": {
                    "type": "Point",
                    "coordinates": [
                        -87.917484,
                        42.158084
                    ],
                    "interpolated": true
                },
                "address": "825",
                "context": [{
                        "id": "neighborhood.287187",
                        "text": "Lake Cook Road"
                    },
                    {
                        "id": "postcode.11727721238210580",
                        "text": "60089"
                    },
                    {
                        "id": "place.8589721255665070",
                        "wikidata": "Q967086",
                        "text": "Buffalo Grove"
                    },
                    {
                        "id": "region.3290978600358810",
                        "short_code": "US-IL",
                        "wikidata": "Q1204",
                        "text": "Illinois"
                    },
                    {
                        "id": "country.9053006287256050",
                        "short_code": "us",
                        "wikidata": "Q30",
                        "text": "United States"
                    }
                ]
            },
            {
                "id": "address.240107872738130",
                "type": "Feature",
                "place_type": [
                    "address"
                ],
                "relevance": 0.5,
                "properties": {},
                "text": "Milwaukee Avenue",
                "place_name": "825 Milwaukee Avenue, Wheeling, Illinois 60090, United States",
                "matching_text": "South Milwaukee Avenue",
                "matching_place_name": "825 South Milwaukee Avenue, Wheeling, Illinois 60090, United States",
                "center": [
                    -87.898319,
                    42.126289
                ],
                "geometry": {
                    "type": "Point",
                    "coordinates": [
                        -87.898319,
                        42.126289
                    ],
                    "interpolated": true,
                    "omitted": true
                },
                "address": "825",
                "context": [{
                        "id": "neighborhood.287189",
                        "text": "Milwaukee Avenue"
                    },
                    {
                        "id": "postcode.9418633295906190",
                        "text": "60090"
                    },
                    {
                        "id": "place.9902190947082220",
                        "wikidata": "Q935043",
                        "text": "Wheeling"
                    },
                    {
                        "id": "region.3290978600358810",
                        "short_code": "US-IL",
                        "wikidata": "Q1204",
                        "text": "Illinois"
                    },
                    {
                        "id": "country.9053006287256050",
                        "short_code": "us",
                        "wikidata": "Q30",
                        "text": "United States"
                    }
                ]
            }
        ],
        "attribution": "NOTICE: © 2018 Mapbox and its suppliers. All rights reserved. Use of this data is subject to the Mapbox Terms of Service (https://www.mapbox.com/about/maps/). This response and the information it contains may not be retained. POI(s) provided by Foursquare."
    }
""".data(using: .utf8)!
    
    func tesst() {
        let decoder = JSONDecoder()
        do {
            let placeMarkStores = try decoder.decode(PlaceMarkService.self, from: json)
            let placeMarks = PlaceMark(from: placeMarkStores)
            
            //for placeMark in placeMarks {
            for placeMarkName in placeMarks.Name {
                print("\(placeMarkName)\n")
            }
            for placeMarkPlaceName in placeMarks.placeName {
                print("\(placeMarkPlaceName)\n\n")
            }
        }catch {
            print("Unexpected error: \(error).")
        }
        
        
    }
}


struct PlaceMark {
    
    var placeName: [String] = []
    var Name: [String] = []
    var coordinates: [[Double]] = []
    
    private enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case Name = "text"
        case coordinates
    }
    
//    var json: Data? {
//        return try? JSONDecoder().decode(self)
//    }
}

struct PlaceMarkService: Decodable {
    
    var type: String?
    var query: [String]?
    var features: [feature]
    
   
    
    struct feature: Decodable {
        var id: String
        var type: String
        var place_type: [String]
        var relevance: Double
        var properties: property
        
        struct property: Decodable {
            var markerColor: String?
            var markerSize: String?
            var markerSymbol: String?
            
             private enum CodingKeys: String, CodingKey {
                case markerColor = "marker-color"
                case markerSize = "marker-size"
                case markerSymbol = "marker-symbol"
            }
        }
        
        var text: String
        var place_name: String
        var matching_text: String?
        var matching_place_name: String?
        var center: [Double]
        var geometry: Geometry
        
        struct Geometry: Decodable {
            var type: String
            var coordinates: [Double]
            var interpolated: Bool?
            var omitted: Bool?
        }
        
        var address: String?
        var context: [Context]?
        
        
        struct Context: Decodable {
            var id: String?
            var short_code: String?
            var wikidata: String?
            var text: String?
        }
        
       
        
        
    }
    
     var attribution: String
}

extension PlaceMark {
    init(from service: PlaceMarkService) {
        for Feature in service.features {
            placeName.append(Feature.place_name)
            Name.append(Feature.text)

            let Geometry = Feature.geometry
            coordinates.append(Geometry.coordinates)

        }
            
//            placeName = service.place_name
//            Name = service.text
//
//            let Geometry = service.geometry
//            coordinates = Geometry.coordinates
    }
}
