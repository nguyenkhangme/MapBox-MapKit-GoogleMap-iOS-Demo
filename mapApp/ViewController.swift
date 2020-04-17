//
//  ViewController.swift
//  mapApp
//
//  Created by Vinova on 4/17/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit

import MapboxGeocoder

import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
//import Mapbox

#if !os(tvOS)
    import Contacts
#endif



class ViewController: UIViewController, UISearchBarDelegate, MGLMapViewDelegate {

    let geocoder = Geocoder.shared
    
    lazy var Mapp = Map(latitude: 40.74699,longtitude: -73.98742,title: "Central Park",subtitle: "The biggest park in New York City!")
    //, coordinate: ["latitude": 40.74699, "longtitude": 40.74699])
    
    //@IBOutlet weak var searchTextField: UITextField!
    
    lazy var mapView = NavigationMapView(frame: view.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //searchTextField.delegate = self
        
        // Set the map view's delegate
         
          mapView.delegate = self
          
  
        
        let url = URL(string: "mapbox://styles/mapbox/streets-v11")
        
        //print("AASASDASDSAD: \(String(describing: Mapp.coordinate["latitude"]))")
    
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       // mapView.setCenter(CLLocationCoordinate2D(latitude: Mapp.latitude , longitude: Mapp.longtitude), zoomLevel: 9, animated: false)
       
        view.addSubview(mapView)
       //mapView.styleURL = MGLStyle.satelliteStyleURL
        mapView.styleURL = url
        
     
        
 
        
  // Allow the map view to display the user's location
    
        mapView.showsUserLocation = true
        
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
    
        
        
        
        
        // MARK: Search
        
      

        
        
  
        
   }
    
    @IBAction func searchPlace(_ sender: UIBarButtonItem) {
        
        
        let searchController = UISearchController(searchResultsController: nil)

        searchController.searchBar.delegate = self



        present(searchController, animated: true, completion: nil)
        
//        let query = searchTextField.text
//
//        search(query: query)
//
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //func search(query: String!) {
//        UIApplication.shared.beginIgnoringInteractionEvents()
//
        //view.isUserInteractionEnabled = true

        let activityIndicator = UIActivityIndicatorView()

        activityIndicator.style = UIActivityIndicatorView.Style.medium

        activityIndicator.center = self.view.center

        activityIndicator.hidesWhenStopped = true

        activityIndicator.startAnimating()

        self.view.addSubview(activityIndicator)
        
            //Search
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            
        
            

            // To refine the search, you can set various properties on the options object.
            

    //            #if !os(tvOS)
    //                let formatter = CNPostalAddressFormatter()
    //                print(formatter.string(from: placemark.postalAddress!))
    //                    // 200 Queen St
    //                    // Saint John New Brunswick E2L 2X1
    //                    // Canada
    //            #endif
            }

   
            
            // MARK: Add a point annotation
            
           
            
            DispatchQueue.main.async {
                
                let options = ForwardGeocodeOptions(query: searchBar.text!)
                
                options.allowedISOCountryCodes = ["CA"]
                options.focalLocation = CLLocation(latitude: 45.3, longitude: -66.1)
                options.allowedScopes = [.address, .pointOfInterest]

                _ = self.geocoder.geocode(options) { (placemarks, attribution, error) in
                    guard let placemark = placemarks?.first else {
                        return
                    }

                    print(placemark.name)
                        // 200 Queen St
                    
                    self.Mapp.title = placemark.name
                    self.Mapp.subtitle = placemark.qualifiedName!
                   // print(placemark.qualifiedName)
                        // 200 Queen St, Saint John, New Brunswick E2L 2X1, Canada

                    let coordinate = placemark.location!.coordinate
                    self.Mapp.latitude = coordinate.latitude
                    self.Mapp.longtitude = coordinate.longitude
                    print("\(coordinate.latitude), \(coordinate.longitude)")
                    
                    let annotation = MGLPointAnnotation()
                                      
                    annotation.coordinate = CLLocationCoordinate2D(latitude: self.Mapp.latitude, longitude: self.Mapp.longtitude)
                    
                    print("annotation coordinate: \(annotation.coordinate)")
                    
                    annotation.title = self.Mapp.title
                    annotation.subtitle = self.Mapp.subtitle
                    self.mapView.addAnnotation(annotation)
                    
                    }
                        // 45.270093, -66.050985
                    activityIndicator.stopAnimating()
                                      //
                                      //
                    //self.view.isUserInteractionEnabled = false
                    
                
                
        }
 
    
    

    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
   // Always allow callouts to popup when annotations are tapped.
   return true
   }
    
   func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
   
    let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 4500, pitch: 15, heading: 180)
   
    mapView.fly(to: camera, withDuration: 4, peakAltitude: 3000, completionHandler: nil)
   
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//           searchTextField.resignFirstResponder()
//       }
    
   }

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

