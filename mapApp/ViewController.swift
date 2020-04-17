//
//  ViewController.swift
//  mapApp
//
//  Created by Vinova on 4/17/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit

import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate, UISearchBarDelegate {

    lazy var Mapp = Map(latitude: 40.74699,longtitude: -73.98742,title: "Central Park",subtitle: "The biggest park in New York City!")
    //, coordinate: ["latitude": 40.74699, "longtitude": 40.74699])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let url = URL(string: "mapbox://styles/mapbox/streets-v11")
        
        //print("AASASDASDSAD: \(String(describing: Mapp.coordinate["latitude"]))")
    
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: Mapp.latitude , longitude: Mapp.longtitude), zoomLevel: 9, animated: false)
       view.addSubview(mapView)
       //mapView.styleURL = MGLStyle.satelliteStyleURL
        mapView.styleURL = url
        
       // Add a point annotation
       let annotation = MGLPointAnnotation()
       annotation.coordinate = CLLocationCoordinate2D(latitude: 40.77014, longitude: -73.97480)
        annotation.title = Mapp.title
        annotation.subtitle = Mapp.subtitle
       mapView.addAnnotation(annotation)
        
       // Set the map view's delegate
       mapView.delegate = self
        
       // Allow the map view to display the user's location
       mapView.showsUserLocation = true
   }
    
    @IBAction func searchPlace(_ sender: UIBarButtonItem) {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        <#code#>
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
   // Always allow callouts to popup when annotations are tapped.
   return true
   }
    
   func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
   let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 4500, pitch: 15, heading: 180)
   mapView.fly(to: camera, withDuration: 4,
   peakAltitude: 3000, completionHandler: nil)
   }
   }


