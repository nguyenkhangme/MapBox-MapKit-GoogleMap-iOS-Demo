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


#if !os(tvOS)
    import Contacts
#endif


class LocationSearchTableViewController: UITableViewController {
    
    var sharedFetchData = FetchData.shared
    
    var tessst = FetchData()
    
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

    var matchingItems: [GeocodedPlacemark] = []
    
    var matchingItems1 = PlaceMark()
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems1.Name.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        
        cell.textLabel?.text = matchingItems1.Name[indexPath.row]
        cell.detailTextLabel?.text = matchingItems1.placeName[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //API
        let selectedItem1 = matchingItems1
        handleMapSearchDelegate?.addAnnotationAPI(placemark: selectedItem1, row: indexPath.row)
        dismiss(animated: true, completion: nil)
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
        
        
        tessst.HandleModelSearchDelegate = self
        _ = tessst.fetchData(query: searchController.searchBar.text ?? "", coordinate:self.mapView.userLocation!.coordinate)
        //tessst.loadData(query: searchController.searchBar.text ?? "", coordinate:self.mapView.userLocation!.coordinate)
      
    }

}

extension LocationSearchTableViewController : HandleModelSearch {

    func addPlaceMark1(name: [String], qualified_Name: [String], coordinates: [[Double]]) {
        print("OK Delegate Table View in location search")
        matchingItems1.Name = name
        matchingItems1.placeName = qualified_Name
        matchingItems1.coordinates = coordinates
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
}
