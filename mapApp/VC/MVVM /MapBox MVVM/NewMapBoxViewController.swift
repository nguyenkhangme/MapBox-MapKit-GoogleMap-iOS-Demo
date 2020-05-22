//
//  GoogleMapViewController.swift
//  mapApp
//
//  Created by user on 5/15/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit

import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class NewMapBoxViewController: UIViewController {
    
    var spacing: CGFloat = 0.0
    var customView = UIView()
    var viewModel = MainViewModel(modelAcess: .MapBox)
    lazy var SearchTable = SearchTableViewController()
    var directionsRoute: Route?
    
    lazy var mapView = NavigationMapView(frame: view.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //SearchTable.modelAccess = .MapBox
        SearchTable.handleMapSearchDelegate = self
        
        configureMap()
        configureActivityIndicator()
      
        configureSearchButton()
        
        self.view.addSubview(customView)
        configureGoToUserLocationButton()
        configureCustomView()
        
        
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    func updateUserLocation(){ //Just Idea
        while viewModel.userLocation != self.mapView.userLocation!.coordinate {
            viewModel.userLocation = self.mapView.userLocation!.coordinate
            //Dat ham nay o dau?
            //Neu dang di dung lai va hai ve bang nhau?
            //Neu di den diem dung, trong ham duoi da xu ly chua?
            self.calculateRoute(from: (self.mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
                if error != nil {
                    
                    print("Error calculating route")
                           //activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    //MARK: Configure CustomView
    func configureCustomView(){
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: customView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: customView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        print("customViewAdd!")
        
        
    }
    
    // MARK: GoToUserLocationButton
    
    func configureGoToUserLocationButton(){
        let GoToUserLocationButton = UIButton()
        GoToUserLocationButton.addTarget(self, action: #selector(GoToUserLocation), for: .touchUpInside)
        GoToUserLocationButton.backgroundColor = .black
        GoToUserLocationButton.setTitle("👤", for: .normal)
        GoToUserLocationButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).withSize(27)
        GoToUserLocationButton.translatesAutoresizingMaskIntoConstraints = false
        //customView.frame.origin = CGPoint(x:view.bounds.maxX-spacing,y:view.bounds.maxY/2)
        
        self.customView.addSubview(GoToUserLocationButton)
          
        let viewsDictionary = ["GoToUserLocationButton": GoToUserLocationButton]
           
        let GoToUserLocationButton_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[GoToUserLocationButton]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
                 
        let GoToUserLocationButton_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[GoToUserLocationButton]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        
          customView.addConstraints(GoToUserLocationButton_H)
          customView.addConstraints(GoToUserLocationButton_V)
        print("ButtonAdd!")
        
    }
    
    @objc func GoToUserLocation(){
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
    }
    
    //MARK: viewWillLayoutSubviews
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        customView.bounds.origin = CGPoint(x:view.bounds.maxX-spacing,y:view.bounds.maxY/2)
    }
    
    func configureGoToNavigationViewButton(){
        let barButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPlace))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    
    
    //MARK: Search Button
    
    func configureSearchButton(){
        let barButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPlace))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func searchPlace() {
        
        viewModel.userLocation = self.mapView.userLocation!.coordinate
        print("user Location: \(self.mapView.userLocation!.coordinate)")
        SearchTable.setViewModel(viewModel: viewModel)
               
        let searchController = UISearchController(searchResultsController: SearchTable)
               
        searchController.searchResultsUpdater = SearchTable

        searchController.searchBar.delegate = self
               
        searchController.searchBar.placeholder = "Search for places"
               
        searchController.searchBar.resignFirstResponder()
        
        present(searchController, animated: true, completion: nil)
    }

    
    //MARK: configureMap
    
    func configureMap(){
        
        // Set the map view's delegate
              definesPresentationContext = true
               
              mapView.delegate = self
                
              let url = URL(string: "mapbox://styles/mapbox/streets-v11")

              mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
             // mapView.setCenter(CLLocationCoordinate2D(latitude: Mapp.latitude , longitude: Mapp.longtitude), zoomLevel: 9, animated: false)
             
              view.addSubview(mapView)
             //mapView.styleURL = MGLStyle.satelliteStyleURL
              mapView.styleURL = url
              

        // Allow the map view to display the user's location
          
              mapView.showsUserLocation = true
              
              mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        
        
        
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
    
    //MARK: Remove All Annotations
    
    func removeAllAnnotations() {
      
      guard let annotations = mapView.annotations else { return print("Annotations Error") }
      
      if annotations.count != 0 {
        for annotation in annotations {
          mapView.removeAnnotation(annotation)
        }
      } else {
        return
      }
    }
    
    //MARK: UpdateViewFromViewModel
    
    let annotation = MGLPointAnnotation()
    
    func UpdateViewFromModel(){
        
        
        mapView.clearsContextBeforeDrawing = true
        mapView.removeRoutes()
        removeAllAnnotations()
               
        
                                                    
        guard let longitude = self.viewModel.placeMark.longitude else {
            return
        }
        guard let latitude = self.viewModel.placeMark.latitude else {
            return
        }
        guard let name = self.viewModel.placeMark.Name else {
            return
        }
        guard let placeName = self.viewModel.placeMark.placeName else {
            return
        }
        print("self.viewModel.placeMark: \(self.viewModel.placeMark)")
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                  
        print("annotation coordinate update view from model: \(annotation.coordinate)")
               
        annotation.title = name
        
        annotation.subtitle = placeName
               
        activityIndicator.startAnimating()
               print("star animating...")
               
        self.mapView.addAnnotation(annotation)
               
               
        self.calculateRoute(from: (self.mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
        if error != nil {
                   print("Error calculating route")
                   //activityIndicator.stopAnimating()
               }
    }
    }
    
    //MARK: layoutTrait
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        super.traitCollectionDidChange(previousTraitCollection)

        layoutTrait(traitCollection: traitCollection)
    }
   
    func layoutTrait(traitCollection: UITraitCollection)
    {
        if traitCollection.horizontalSizeClass == .compact, traitCollection.verticalSizeClass == .regular {
            
            spacing = 12
            
        }
        else {
            
            spacing = 24
        }
    }
    
    // MARK: Calculate and Draw Route
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
                guard let directionRouteCheck = self.directionsRoute else {
                    return
                }
            // Draw the route on the map after creating it
            self.drawRoute(route: directionRouteCheck)
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
            activityIndicator.stopAnimating()
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
            activityIndicator.stopAnimating()
            print("stop animating")
        }
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

extension NewMapBoxViewController: UISearchBarDelegate{
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
        viewModel.placeMark.Name = PlaceMarkForAllMap.shared[0].Name
           viewModel.placeMark.placeName = PlaceMarkForAllMap.shared[0].placeName
           viewModel.placeMark.longitude = PlaceMarkForAllMap.shared[0].longitude
           viewModel.placeMark.latitude = PlaceMarkForAllMap.shared[0].latitude
           
           UpdateViewFromModel()
            
            UpdateViewFromModel()

            SearchTable.dismiss(animated: true, completion: nil)
   
        }
}

extension NewMapBoxViewController: MGLMapViewDelegate {
    
    //Show annotation information
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
         return true
     }
      
     
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {

     let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 4500, pitch: 15, heading: 180)

     mapView.fly(to: camera, withDuration: 4, peakAltitude: 3000, completionHandler: nil)

     }
}

extension NewMapBoxViewController: HandleMapSearch {
    func addAnnotationAPI(placemark: PlaceMark, row: Int) {
        
    }
    
    func addAnnotationFromSearch(placeMarks: [PlaceMarkForAllMap], row: Int) {
        viewModel.placeMark.Name = placeMarks[row].Name
        viewModel.placeMark.placeName = placeMarks[row].placeName
        viewModel.placeMark.longitude = placeMarks[row].longitude
        viewModel.placeMark.latitude = placeMarks[row].latitude
        
        UpdateViewFromModel()
        
    }
    
    
}
