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
    
    var queryService = MainQueryService(queryServiceAccess: .AppleMaps)
    lazy var searchTable = SearchTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false

        
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

    func configureSearchButton(){
        let barButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPlace))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func searchPlace() {
       // viewModel.userLocation = self.mapView.userLocation!.coordinate
        //print("user Location: \(self.mapView.userLocation!.coordinate)")
        searchTable.setQueryService(queryService: queryService)
        
        let searchController = UISearchController(searchResultsController: searchTable)
               
        searchController.searchResultsUpdater = searchTable

        searchController.searchBar.delegate = self
               
        searchController.searchBar.placeholder = "Search for places"
               
        searchController.searchBar.resignFirstResponder()
        
        present(searchController, animated: true, completion: nil)
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

extension AppleMapsViewController: UISearchBarDelegate{
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            //activityIndicatorX.startAnimating()

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
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            AppleMapView.setRegion(region, animated: true)
        }
        
    }
}
