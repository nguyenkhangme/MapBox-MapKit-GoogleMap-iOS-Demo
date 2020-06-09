//
//  AppleMapsViewController.swift
//  mapApp
//
//  Created by user on 5/18/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit
import MapKit

class AppleMapsViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var AppleMapView: MKMapView!
    
    //Use Google Search for Apple Maps
    var queryService = MainQueryService(queryServiceAccess: .MapBox)
    var whatIndexOfViewModelInViewModels = 0
    var mapsViewModels = [MapsViewModel(modelAccess: .AppleMaps)]
    var mapsViewModel = MapsViewModel(modelAccess: .MapBox) //For Pass user location
    var annotation = MKPointAnnotation()
    var location = CLLocation()
    var userCoordinate : CLLocationCoordinate2D?
    var annotations = [MKPointAnnotation]()

    lazy var searchTable = SearchTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppleMapView.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = false
        searchTable.handleMapSearchDelegate = self
        configureActivityIndicator()
        configureSearchButton()
        configureMap()
        
        // Do any additional setup after loading the view.
    }

    func configureMap(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    //MARK: Search
    
    func configureSearchButton(){
        let barButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPlace))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func searchPlace() {
        
        mapsViewModel.userLocation = userCoordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)

        searchTable.setQueryService(queryService: queryService)
        searchTable.setMapsViewModel(mapsViewModel: mapsViewModel)
       // viewModel.userLocation = self.mapView.userLocation!.coordinate
        //print("user Location: \(self.mapView.userLocation!.coordinate)")
        //searchTable.setQueryService(queryService: queryService)
        
        let searchController = UISearchController(searchResultsController: searchTable)
               
        searchController.searchResultsUpdater = searchTable

        searchController.searchBar.delegate = self
               
        searchController.searchBar.placeholder = "Search for places"
               
        searchController.searchBar.resignFirstResponder()
        
        present(searchController, animated: true, completion: nil)
    }
    
    // MARK: Update View From Model
    
    func UpdateViewFromModel(){
        
        
       // mapView.clearsContextBeforeDrawing = true
        //mapView.removeRoutes()
        AppleMapView.removeAnnotations(AppleMapView.annotations)
        
        print("Test 1")
                                                    
        guard let longitude = self.mapsViewModels[whatIndexOfViewModelInViewModels].longitude else {
            return
        }
        guard let latitude = self.mapsViewModels[whatIndexOfViewModelInViewModels].latitude else {
            return
        }
        guard let name = self.mapsViewModels[whatIndexOfViewModelInViewModels].Name else {
            return
        }
        guard let placeName = self.mapsViewModels[whatIndexOfViewModelInViewModels].placeName else {
            return
        }
        
        
    
        print("AAAAAA: \(longitude), \(latitude), \(name), \(placeName)")
        
        self.navigationItem.title = name
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        
        print("annotation coordinate update view from model: \(annotation.coordinate)")
               
        annotation.title = name
        
        annotation.subtitle = placeName
        
        activityIndicator.startAnimating()
               print("star animating...")
               
      AppleMapView.addAnnotation(annotation)
        
        var spanData = CLLocationDegrees()
        if (2*abs(location.coordinate.latitude-annotation.coordinate.latitude) > 2*abs(location.coordinate.longitude-annotation.coordinate.longitude)) {
            
            spanData = (2*abs(location.coordinate.latitude-annotation.coordinate.latitude) + 0.01)
        } else {
            spanData = (2*abs(location.coordinate.longitude-annotation.coordinate.longitude) + 0.01)
        }
       
        
        
        let span = MKCoordinateSpan(latitudeDelta: spanData, longitudeDelta: spanData)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        
        //selectedPin = .init(coordinate: annotation.coordinate)
        
        
        AppleMapView.setRegion(region, animated: true)
        
        activityIndicator.stopAnimating()
               
     
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
    
    @objc func getDirections(){
        
        let selectedPin = MKPlacemark(coordinate: annotation.coordinate)
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
        
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

//MARK: searchBarSearchButtonClicked

extension AppleMapsViewController: UISearchBarDelegate{
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            activityIndicator.startAnimating()
            
            var tempp = MapsViewModel(modelAccess: .AppleMaps)
        
       
        //mapsViewModels.removeAll()
            mapsViewModels = PlaceMarkForAllMap.shared.map({ return tempp.setMapsModel(mapsModelAccess: $0)})
            
         //print("\(mapsViewModels)")
        AppleMapView.removeAnnotations(annotations)

        annotations.removeAll()
        
        
            for i in mapsViewModels.indices{
                print("i:\(i)\n")
            guard let longitude = self.mapsViewModels[i].longitude else {
                       return
                   }
                   guard let latitude = self.mapsViewModels[i].latitude else {
                       return
                   }
                   guard let name = self.mapsViewModels[i].Name else {
                       return
                   }
                   guard let placeName = self.mapsViewModels[i].placeName else {
                       return
                   }
                
                let temp = MKPointAnnotation()
               
                temp.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                          
                //print("annotation name update view from model: \(annotation)")
                       
                temp.title = name
                
                temp.subtitle = placeName

                //Why it's not work exactly if we use this function? (Test: Print annotations exactly but can not show it in the map!)
                //let temp = addAnnotations(longitude: longitude, latitude: latitude, name: name, placeName: placeName)
                print("\(temp)")
            
                annotations.append(temp)
                
                print("annotation name update view from model: \(String(describing: annotations[i].title))")
                
                AppleMapView.addAnnotation(annotations[i])
                
            }

            
            activityIndicator.stopAnimating()
            searchTable.dismiss(animated: true, completion: nil)
   
        }
}

extension AppleMapsViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("sds")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let location = locations.first {
        self.location = location
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        AppleMapView.setRegion(region, animated: true)
        //let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        }
        
    }
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

//Hndle Map Search

extension AppleMapsViewController: HandleMapSearch {
    func parseDataFromSearch(viewModel: [MapsViewModel], row: Int) {
       
        //Way 2
        mapsViewModels = viewModel
        whatIndexOfViewModelInViewModels = row
        UpdateViewFromModel()
    }
    
    func addAnnotationAPI(placemark: PlaceMark, row: Int) {
        
    }
    
    func addAnnotationFromSearch(placeMarks: [PlaceMarkForAllMap], row: Int) {
        
    }
    
    
}

extension AppleMapsViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = .orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "BackButton"), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }


    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //if annotation View is user?
      if view.annotation?.coordinate == userCoordinate { return }
        annotation = view.annotation as! MKPointAnnotation
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        userCoordinate = mapView.userLocation.location?.coordinate
    }
}
