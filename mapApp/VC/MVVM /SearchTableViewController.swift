//
//  LocationSearchTableViewController.swift
//  mapApp
//
//  Created by Vinova on 4/21/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit


class SearchTableViewController: UITableViewController {
    
   // var modelAccess: ViewModel.Type
    lazy var viewModel = MainViewModel(modelAcess: .AppleMaps)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
       // self.tableView.register(SearchTableViewCellTableViewCell.self, forCellReuseIdentifier: "searchCell")
        
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
        
//        let cell:SearchTableViewCellTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCellTableViewCell
//
//
//
////         if let myCell = cell as? SearchTableViewCellTableViewCell {
//
//        cell.Title?.text = self.matchingItems[indexPath.row].Name
//        cell.subTitle?.text = self.matchingItems[indexPath.row].placeName
//            print("\(String(describing: cell.Title)) ")
//
//            return myCell
//        }
        
        let identifier = "searchCell"

        var myCell: SearchTableViewCellTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchTableViewCellTableViewCell

          if myCell == nil {
            tableView.register(UINib(nibName: "SearchTableViewCellTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            myCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SearchTableViewCellTableViewCell
            }
        
        myCell.Title?.text = self.matchingItems[indexPath.row].Name
        myCell.subTitle?.text = self.matchingItems[indexPath.row].placeName
            print("\(String(describing: myCell.Title)) ")
        
        return myCell
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
