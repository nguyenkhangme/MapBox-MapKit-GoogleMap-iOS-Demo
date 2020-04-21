//
//  LocationSearchTableViewController.swift
//  mapApp
//
//  Created by Vinova on 4/21/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit

import MapboxGeocoder

import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

import MapKit

#if !os(tvOS)
    import Contacts
#endif

class LocationSearchTableViewController: UITableViewController {
    
    let geocoder = Geocoder.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    var handleMapSearchDelegate:HandleMapSearch? = nil

    lazy var mapView = NavigationMapView()
    var matchingItems:[MKMapItem] = []
    var matchingItems1: [GeocodedPlacemark] = []
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //let selectedItem = matchingItems[indexPath.row].placemark
        let selectedItem = matchingItems1[indexPath.row - 1]
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = selectedItem.qualifiedName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.creatAnnotation(query: selectedItem.name ?? " ")
        
        let selectedItem1 = matchingItems1[indexPath.row]
        handleMapSearchDelegate?.addAnnotation(placemark: selectedItem1)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LocationSearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
//        guard //let mapView? = mapView,
//            let searchBarText = searchController.searchBar.text else { return }
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = searchBarText
//        //request.region = mapView.region
//        let search = MKLocalSearch(request: request)
//        search.start { response, _ in
//            guard let response = response else {
//                return
//            }
//            self.matchingItems = response.mapItems
//            self.tableView.reloadData()
//        }
        
        let options = ForwardGeocodeOptions(query: searchController.searchBar.text ?? "")
        
        options.allowedISOCountryCodes = ["CA"]
        //specific, near//options.focalLocation = CLLocation(latitude: 45.3, longitude: -66.1)
        options.allowedScopes = [.address, .pointOfInterest]

        _ = self.geocoder.geocode(options) { (placemarks, attribution, error) in
//            guard let placemark = placemarks?.first else {
//                return
//            }
//
//            self.matchingItems1.append(placemark)
            if let placemarksX = placemarks {
                
                self.matchingItems1 = placemarksX
                
            } else {
                return
            }
            
            self.tableView.reloadData()
            print("placemark: \(String(describing: placemarks)),\nmatching: \(self.matchingItems1)")
        }
        
    }

}
