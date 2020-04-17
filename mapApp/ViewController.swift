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
    
    var directionsRoute: Route?
    
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
        
    mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
    //func search(query: String!) {
//        UIApplication.shared.beginIgnoringInteractionEvents()
//
        //view.isUserInteractionEnabled = true

        
        
            //Search
        
//        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
//
//
//
//
//            // To refine the search, you can set various properties on the options object.
//
//
//    //            #if !os(tvOS)
//    //                let formatter = CNPostalAddressFormatter()
//    //                print(formatter.string(from: placemark.postalAddress!))
//    //                    // 200 Queen St
//    //                    // Saint John New Brunswick E2L 2X1
//    //                    // Canada
//    //            #endif
//            }

   
            
          
           
            
            DispatchQueue.main.async {
                
                let activityIndicator = UIActivityIndicatorView()

                activityIndicator.style = UIActivityIndicatorView.Style.medium

                activityIndicator.center = self.view.center

                activityIndicator.hidesWhenStopped = true

                activityIndicator.startAnimating()

                self.view.addSubview(activityIndicator)
                
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
                    
                    // MARK: Add a point annotation
                              
                    
                    let annotation = MGLPointAnnotation()
                                      
                    annotation.coordinate = CLLocationCoordinate2D(latitude: self.Mapp.latitude, longitude: self.Mapp.longtitude)
                    
                    print("annotation coordinate: \(annotation.coordinate)")
                    
                    annotation.title = self.Mapp.title
                    annotation.subtitle = self.Mapp.subtitle
                    self.mapView.addAnnotation(annotation)
                    
                    self.calculateRoute(from: (self.mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
                        if error != nil {
                            print("Error calculating route")
                            activityIndicator.stopAnimating()
                        }
                        else {
                            activityIndicator.stopAnimating()
                            
                        }
                    }
                    
                    activityIndicator.stopAnimating()
                    
                   
                    
                    }
                
                //activityIndicator.stopAnimating()
                        // 45.270093, -66.050985
                   
                                      //
                                      //
                    //self.view.isUserInteractionEnabled = false
                    
                
                
        }
 
    
    

    }
    
    func calculateRoute(from origin: CLLocationCoordinate2D,
    to destination: CLLocationCoordinate2D,
    completion: @escaping (Route?, Error?) -> ()) {
     
    // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
    let origin = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Start")
    let destination = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
     
    // Specify that the route is intended for automobiles avoiding traffic
    let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
     
    // Generate the route object and draw it on the map
    _ = Directions.shared.calculate(options) { [unowned self] (waypoints, routes, error) in
    self.directionsRoute = routes?.first
    // Draw the route on the map after creating it
    self.drawRoute(route: self.directionsRoute!)
    }
    }
     
    func drawRoute(route: Route) {
         //mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
        guard route.coordinateCount > 0 else { return }
        // Convert the route’s coordinates into a polyline
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
         
        // If there's already a route line on the map, reset its shape to the new route
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
             
            // Customize the route line color and width
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.1897518039, green: 0.3010634184, blue: 0.7994888425, alpha: 1))
            lineStyle.lineWidth = NSExpression(forConstantValue: 3)
             
            // Add the source and style layer of the route line to the map
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
    

    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
     
    // Present the navigation view controller when the callout is selected
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigationViewController = NavigationViewController(for: directionsRoute!)
        navigationViewController.modalPresentationStyle = .fullScreen
        self.present(navigationViewController, animated: true, completion: nil)
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

