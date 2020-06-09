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
    var queryService = MainQueryService(queryServiceAccess: .Google)
    var mapsViewModel = MapsViewModel(modelAccess: .MapBox)
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
        navigationController?.navigationBar.prefersLargeTitles = false

        searchTable.handleMapSearchDelegate = self
        
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
    
    //MARK: Search Setup
    
    func configureSearchButton(){
        let barButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPlace))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func searchPlace() {
        
        //viewModel.userLocation = self.mapView.userLocation!.coordinate
        //print("user Location: \(self.mapView.userLocation!.coordinate)")
        print("")
        searchTable.setQueryService(queryService: queryService)
               
        let searchController = UISearchController(searchResultsController: searchTable)
        
               
        searchController.searchResultsUpdater = searchTable

        searchController.searchBar.delegate = self
               
        searchController.searchBar.placeholder = "Search for places"
               
        searchController.searchBar.resignFirstResponder()
        
        present(searchController, animated: true, completion: nil)
    }
    
    //MARK: Configure Map

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

    //MARK: - Declare and configureActivityIndicator
        let activityIndicator = UIActivityIndicatorView()
        
        func configureActivityIndicator(){
            activityIndicator.style = UIActivityIndicatorView.Style.medium

            activityIndicator.center = self.view.center

            activityIndicator.hidesWhenStopped = true

            self.view.addSubview(activityIndicator)
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    //        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    //        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        }
    
    //MARK: UpdateViewFromViewModel
    
    let marker = GMSMarker()
    
    func UpdateViewFromModel(){
        
        
        mapView.clearsContextBeforeDrawing = true
        //mapView.removeRoutes()
        //removeAllAnnotations()
               
        
                                                    
        guard let longitude = self.mapsViewModel.longitude else {
                   return
               }
        guard let latitude = self.mapsViewModel.latitude else {
                   return
               }
        guard let name = self.mapsViewModel.Name else {
                   return
               }
        guard let placeName = self.mapsViewModel.placeName else {
                   return
               }
        
        
        self.navigationItem.title = name
        
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                  
        
               
        marker.title = name
        
        marker.snippet = placeName
               
//        activityIndicator.startAnimating()
//               print("star animating...")
               
        marker.map = mapView
               
               
    }
    
    

}

extension GoogleMapViewController: UISearchBarDelegate{
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //mapsViewModel.setMapsModel(mapsModelAccess: PlaceMarkForAllMap.shared[0])
            
        UpdateViewFromModel()

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

extension GoogleMapViewController: HandleMapSearch {
    func parseDataFromSearch(viewModel: [MapsViewModel], row: Int) {
        mapsViewModel = viewModel[row]
        UpdateViewFromModel()

    }
    
    func addAnnotationAPI(placemark: PlaceMark, row: Int) {
        
    }
    
    func addAnnotationFromSearch(placeMarks: [PlaceMarkForAllMap], row: Int) {
        
        mapsViewModel.setMapsModel(mapsModelAccess: placeMarks[row])
        
        UpdateViewFromModel()
        
    }
    
    
}
