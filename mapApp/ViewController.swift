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
    func addAnnotation(placemark: GeocodedPlacemark)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sharedTest.tesst()
       
    
        //searchTextField.delegate = self
        
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
    
    //var resultSearchController:UISearchController? = nil
   
    //resultSearchController = UISearchController(searchResultsController: locationSearchTable)
    //resultSearchController?.searchResultsUpdater = locationSearchTable
    
    @IBOutlet weak var goToUserPlaceButton: UIButton!
    @IBAction func GoToUserLocation(_ sender: Any) {
        
    
        
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
             
    }
    
    @IBAction func searchPlace(_ sender: UIBarButtonItem) {
        
        //let locationSearchTable = LocationSearchTableViewController()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        
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
        
        
        
        mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)

            //DispatchQueue.main.async {
                
                let activityIndicator = UIActivityIndicatorView()

                activityIndicator.style = UIActivityIndicatorView.Style.medium

                activityIndicator.center = self.view.center

                activityIndicator.hidesWhenStopped = true

                activityIndicator.startAnimating()
                
//                activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//                let views = ["view": self.view!, "activityIndicator": activityIndicator]
//                let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-(<=0)-[activityIndicator(100)]", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views)
//                let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-(<=0)-[activityIndicator(100)]", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
//                self.view.addConstraints(horizontalConstraints)
//                self.view.addConstraints(verticalConstraints)

                self.view.addSubview(activityIndicator)
                
                //searchBar.text = self.query
        
//         sharedFetchData.HandleModelSearchDelegate = self
//
//        sharedFetchData.loadData(query: searchBar.text ?? "")
        
        tessst.HandleModelSearchDelegate = self
        tessst.loadData(query: searchBar.text ?? "")
                
//                let options = ForwardGeocodeOptions(query: searchBar.text ?? "")
//
//                //DispatchQueue.global(qos: .userInteractive).async { [weak self] in
//
//
//
//                    options.allowedISOCountryCodes = ["CA"]
//                    //specific, near//options.focalLocation = CLLocation(latitude: 45.3, longitude: -66.1)
//                    options.allowedScopes = [.address, .pointOfInterest]
//
//                    let task = self.geocoder.geocode(options) { (placemarks, attribution, error) in
//                        guard let placemark = placemarks?.first else {
//                            return
//                        }
//
//                        print(placemark.name)
//                            // 200 Queen St
//
//                        self.Mapp.title = placemark.name
//                        self.Mapp.subtitle = placemark.qualifiedName ?? " "
//
//                       // print(placemark.qualifiedName)
//                            // 200 Queen St, Saint John, New Brunswick E2L 2X1, Canada
//
//                       if let coordinate = placemark.location {
//
//                        self.Mapp.latitude = coordinate.coordinate.latitude
//                        self.Mapp.longtitude = coordinate.coordinate.longitude
//
//                        } else {
//                            return
//                        }
//                    }
                //}
                    //print("\(coordinate.latitude), \(coordinate.longitude)")
                    
                    // MARK: Add a point annotation
                              
                    
//                    let annotation = MGLPointAnnotation()
//                                      
//                    annotation.coordinate = CLLocationCoordinate2D(latitude: self.Mapp.latitude, longitude: self.Mapp.longtitude)
//                    
//                    print("annotation coordinate: \(annotation.coordinate)")
//                    
//                    annotation.title = self.Mapp.title
//                    annotation.subtitle = self.Mapp.subtitle
//                    self.mapView.addAnnotation(annotation)
//                    
//                    
//                    
//                    self.calculateRoute(from: (self.mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
//                        if error != nil {
//                            print("Error calculating route")
//                            activityIndicator.stopAnimating()
//                        }
//                        else {
//                            activityIndicator.stopAnimating()
//                            
//                        }
//                    }
                    
                    activityIndicator.stopAnimating()
                    
                
                //activityIndicator.stopAnimating()
       
                    //self.view.isUserInteractionEnabled = false
                    
                
                
        //}
 
    
    

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
            lineStyle.lineColor = NSExpression(forConstantValue: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1))
            lineStyle.lineWidth = NSExpression(forConstantValue: 3)
             
            // Add the source and style layer of the route line to the map
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
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
    func addAnnotation(placemark: GeocodedPlacemark) {
        
        let activityIndicator = UIActivityIndicatorView()

        activityIndicator.style = UIActivityIndicatorView.Style.medium

        activityIndicator.center = self.view.center

        activityIndicator.hidesWhenStopped = true
        
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//          let views = ["view": view!, "activityIndicator": activityIndicator]
//          let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-(<=0)-[activityIndicator(100)]", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views)
//          let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-(<=0)-[activityIndicator(100)]", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
//          view.addConstraints(horizontalConstraints)
//          view.addConstraints(verticalConstraints)

        activityIndicator.startAnimating()

        self.view.addSubview(activityIndicator)
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                
                self!.Mapp.title = placemark.name
                self!.Mapp.subtitle = placemark.qualifiedName ?? " "
                
               // print(placemark.qualifiedName)
                    // 200 Queen St, Saint John, New Brunswick E2L 2X1, Canada

               if let coordinate = placemark.location {
                    
                self!.Mapp.latitude = coordinate.coordinate.latitude
                self!.Mapp.longtitude = coordinate.coordinate.longitude
                    
                } else {
                    return
                }
            }
        
//        self.Mapp.title = placemark.name
//        self.Mapp.subtitle = placemark.qualifiedName ?? " "
//        
//        if let coordinate = placemark.location {
//            
//            self.Mapp.latitude = coordinate.coordinate.latitude
//            self.Mapp.longtitude = coordinate.coordinate.longitude
//            
//        } else {
//            return
//        }
        //let coordinate = placemark.location!.coordinate
        
        
        let annotation = MGLPointAnnotation()
                                             
        annotation.coordinate = CLLocationCoordinate2D(latitude: self.Mapp.latitude, longitude: self.Mapp.longtitude)
                           
        print("annotation coordinate: \(annotation.coordinate)")
                           
        annotation.title = self.Mapp.title
        annotation.subtitle = self.Mapp.subtitle
        self.mapView.addAnnotation(annotation)
        
        self.mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
                           
        self.calculateRoute(from: (self.mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
            if error != nil {
                print("Error calculating route")
                activityIndicator.stopAnimating()
            } else {
                
                activityIndicator.stopAnimating()
                                       
            }
            activityIndicator.stopAnimating()
        }
        
       
        //
    }
   
}

extension ViewController: HandleModelSearch {
    func addPlaceMark1(name: [String], qualified_Name: [String], coordinates: [[Double]]) {
                    DispatchQueue.main.async {
        
            let annotation = MGLPointAnnotation()
                                                 
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(coordinates[0][1]), longitude: CLLocationDegrees(coordinates[0][0]))
                               
           
                               
            annotation.title = name[0]
            annotation.subtitle = qualified_Name[0]
            
            print("annotation coordinate: \(annotation.coordinate), name: \(String(describing: annotation.title)) ")
            self.mapView.addAnnotation(annotation)
            
            self.calculateRoute(from: (self.mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
                if error != nil {
                    print("Error calculating route")
                                          //activityIndicator.stopAnimating()
                }
                                  
            }
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
