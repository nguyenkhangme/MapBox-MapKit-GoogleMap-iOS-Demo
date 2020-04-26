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


protocol HandleMapSearch {
    func addAnnotationAPI(placemark: PlaceMark, row: Int)
}

protocol HandleModelSearch {
    //func addPlaceMark(name: String, qualified_Name: String, longtitude: CLLocationDegrees, latitude: CLLocationDegrees, idx: Int)
    func addPlaceMark1(name: [String], qualified_Name: [String], coordinates: [[Double]])
}

class ViewController: UIViewController, UISearchBarDelegate {
    
     
    
    let sharedTest = test.shared
    
    var sharedFetchData = FetchData.shared
    
    var tessst = FetchData()
  
    
    let geocoder = Geocoder.shared
    
    lazy var Mapp = Map(latitude: 40.74699,longtitude: -73.98742,title: "Central Park",subtitle: "The biggest park in New York City!")
    //, coordinate: ["latitude": 40.74699, "longtitude": 40.74699])
    
    //@IBOutlet weak var searchTextField: UITextField!
    
    lazy var mapView = NavigationMapView(frame: view.bounds)
    
    var query = ""
    
    var directionsRoute: Route?
    
    let activityIndicatorX = UIActivityIndicatorView()
    
    lazy var locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorX.style = UIActivityIndicatorView.Style.medium

        activityIndicatorX.center = self.view.center

        activityIndicatorX.hidesWhenStopped = true

        self.view.addSubview(activityIndicatorX)
        
        sharedTest.tesst()
       
        
        // Set the map view's delegate
        definesPresentationContext = true
         
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
        
        view.addSubview(goToUserPlaceButton)
    
        
   }
    
    
    
    @IBOutlet weak var goToUserPlaceButton: UIButton!
    @IBAction func GoToUserLocation(_ sender: Any) {
        
    
        
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
             
    }
    
    func updateViewFromModel(){
        

        
        mapView.clearsContextBeforeDrawing = true
        
        let annotation = MGLPointAnnotation()
                                             
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.Mapp.latitude, longitude: self.Mapp.longtitude)
                           
        print("annotation coordinate update view from model: \(annotation.coordinate)")
                           
        annotation.title = self.Mapp.title
        annotation.subtitle = self.Mapp.subtitle
        
        self.view.addSubview(activityIndicatorX)
        activityIndicatorX.startAnimating()
        print("star animating...")
        
        self.mapView.addAnnotation(annotation)
        
        
        self.calculateRoute(from: (self.mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
        if error != nil {
            print("Error calculating route")
            //activityIndicator.stopAnimating()
        }
    }
        
    }
    
    @IBAction func searchPlace(_ sender: UIBarButtonItem) {
        
        //let locationSearchTable = LocationSearchTableViewController()
        
        
        locationSearchTable.handleMapSearchDelegate = self
        
        locationSearchTable.mapView = mapView
        
        let searchController = UISearchController(searchResultsController: locationSearchTable)
        
        searchController.searchResultsUpdater = locationSearchTable

        searchController.searchBar.delegate = self
        
        searchController.searchBar.placeholder = "Search for places"
        
        searchController.searchBar.resignFirstResponder()
 
        present(searchController, animated: true, completion: nil)
        

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        

        self.view.addSubview(activityIndicatorX)
        activityIndicatorX.startAnimating()
                
        
        tessst.HandleModelSearchDelegate = self
        tessst.loadData(query: searchBar.text ?? "")
        
        locationSearchTable.dismiss(animated: true, completion: nil)
    

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
            
            self.mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
            activityIndicatorX.stopAnimating()
            print("stop animating")
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
             
            // Customize the route line color and width
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1))
            lineStyle.lineWidth = NSExpression(forConstantValue: 3)
             
            // Add the source and style layer of the route line to the map
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
            
            self.mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
            activityIndicatorX.stopAnimating()
            print("stop animating")
        }
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

extension ViewController: MGLMapViewDelegate {
    
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
}

extension ViewController: HandleMapSearch {
    func addAnnotationAPI(placemark: PlaceMark, row: Int) {
        self.Mapp.title = placemark.Name[row]
        self.Mapp.subtitle = placemark.placeName[row]
        self.Mapp.longtitude = CLLocationDegrees(placemark.coordinates[row][0])
        self.Mapp.latitude = CLLocationDegrees(placemark.coordinates[row][1])
        
        
        updateViewFromModel()
    }
   
}

extension ViewController: HandleModelSearch {
    func addPlaceMark1(name: [String], qualified_Name: [String], coordinates: [[Double]]) {
        
        Mapp.title = name[0]
        Mapp.subtitle = qualified_Name[0]
        Mapp.latitude = CLLocationDegrees(coordinates[0][1])
        Mapp.longtitude = CLLocationDegrees(coordinates[0][0])
        DispatchQueue.main.async {
            self.updateViewFromModel()
        }
    }
    
//    func addPlaceMark(name: String, qualified_Name: String, longtitude: CLLocationDegrees, latitude: CLLocationDegrees, idx: Int)
//    {
//        print("OKDelegate!")
//        if idx == 0 {
//            print("AAAAA: \(name)")
////            Mapp.title = name
////            Mapp.subtitle = qualified_Name
////            Mapp.longtitude = longtitude
////            Mapp.latitude = latitude
//            DispatchQueue.main.async {
//
//                let annotation = MGLPointAnnotation()
//
//                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
//
//
//
//                annotation.title = name
//                annotation.subtitle = qualified_Name
//
//                print("annotation coordinate: \(annotation.coordinate), name: \(String(describing: annotation.title)) ")
//                self.mapView.addAnnotation(annotation)
//
//                self.calculateRoute(from: (self.mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
//                    if error != nil {
//                        print("Error calculating route")
//                                              //activityIndicator.stopAnimating()
//                    }
//
//                }
//            }
//        }
//
//    }
}
