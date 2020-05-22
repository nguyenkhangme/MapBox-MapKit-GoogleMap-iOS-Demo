//
//  LocationSearchTableViewController.swift
//  mapApp
//
//  Created by Vinova on 4/21/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit


class SearchTableViewController: UITableViewController {
    
    var modelAccess: String = ""
    lazy var viewModel = MainViewModel(modelAcess: modelAccess)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        
    }
    
    func setViewModel(viewModel: MainViewModel){
        self.viewModel = viewModel
        
        
    }
    
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    var matchingItems : [PlaceMarkForAllMap] = []
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)

        cell.textLabel?.text = matchingItems[indexPath.row].Name
        cell.detailTextLabel?.text = matchingItems[indexPath.row].placeName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //API
        let selectedItem = matchingItems
        handleMapSearchDelegate?.addAnnotationFromSearch(placeMarks: selectedItem, row: indexPath.row)
        dismiss(animated: true, completion: nil)
    }

}

extension SearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        self.viewModel.getData(query: searchController.searchBar.text ?? "", latitude:viewModel.userLocation.latitude, longitude: viewModel.userLocation.longitude )
        
        self.viewModel._modelAccess?.parseDataDelegate = self
//        guard let matchItems = self.viewModel.placeMarks else {
//            return
//        }
//        matchingItems = MapBoxModel.placeMark
//        //print(MapBoxModel.placeMark)
//        print("matchingItems: \(MapBoxModel.placeMark)")
        

      
    }

}

extension SearchTableViewController : ParseDataFromSearch {
    func parseData(data: [PlaceMarkForAllMap]) {
        
        matchingItems = PlaceMarkForAllMap.shared
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    
}
