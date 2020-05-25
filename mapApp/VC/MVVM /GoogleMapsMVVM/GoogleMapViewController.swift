//
//  GoogleMapViewController.swift
//  mapApp
//
//  Created by user on 5/15/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GoogleMapViewController: UIViewController {
    
    
    lazy var searchTable = SearchTableViewController()
    var viewModel = MainViewModel(modelAcess: .Google)
    
    //MARK: GoogleMap
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    //MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        //searchTable.modelAccess = "Google"

        configureSearchButton()
        configureMap()
        configureGoogleMapsVar()
        // Do any additional setup after loading the view.
        
        
    }
    
    func configureGoogleMapsVar(){
        // Initialize the location manager.
           locationManager = CLLocationManager()
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()
           locationManager.distanceFilter = 50
           locationManager.startUpdatingLocation()
           locationManager.delegate = self

           placesClient = GMSPlacesClient.shared()
    }
    
    func configureSearchButton(){
        let barButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPlace))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func searchPlace() {
        
        //viewModel.userLocation = self.mapView.userLocation!.coordinate
        //print("user Location: \(self.mapView.userLocation!.coordinate)")
        searchTable.setViewModel(viewModel: viewModel)
               
        let searchController = UISearchController(searchResultsController: searchTable)
               
        searchController.searchResultsUpdater = searchTable

        searchController.searchBar.delegate = self
               
        searchController.searchBar.placeholder = "Search for places"
               
        searchController.searchBar.resignFirstResponder()
        
        present(searchController, animated: true, completion: nil)
    }

    func configureMap(){
        
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDictionary: [String:Any] = ["GoogleMapView": mapView!]
        
        let GoogleMapView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[GoogleMapView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        let GoogleMapView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[GoogleMapView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        view.addConstraints(GoogleMapView_H)
        view.addConstraints(GoogleMapView_V)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GoogleMapViewController: UISearchBarDelegate{
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            //activityIndicatorX.startAnimating()

            searchTable.dismiss(animated: true, completion: nil)
   
        }
}


// Delegates to handle events for the location manager.
extension GoogleMapViewController: CLLocationManagerDelegate {

  // Handle incoming location events.
//  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    let location: CLLocation = locations.last!
//    print("Location: \(location)")
//
//    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                          longitude: location.coordinate.longitude,
//                                          zoom: zoomLevel)
//
//    if mapView.isHidden {
//      mapView.isHidden = false
//      mapView.camera = camera
//    } else {
//      mapView.animate(to: camera)
//    }
//
//    listLikelyPlaces()
//  }

  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
      mapView.isHidden = false
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    @unknown default:
      fatalError()
    }
  }

  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
}
