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
    lazy var queryService = MainQueryService(queryServiceAccess: .AppleMaps)
    //Is this make a memory cycle? No
    var mapsViewModel = MapsViewModel(modelAccess: .MapBox)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
       // self.tableView.register(SearchTableViewCellTableViewCell.self, forCellReuseIdentifier: "searchCell")
        configureActivityIndicator()
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
       
        
    }
    
    func setQueryService(queryService: MainQueryService){
        self.queryService = queryService
    }
    
    func setMapsViewModel(mapsViewModel: MapsViewModel){
        self.mapsViewModel = mapsViewModel

    }

    
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    
    //MARK: Change this from PlaceMarkForAllMap to MapsViewModel
    //Change in: ParseDataFromSearch, reuse cell, number of rows
    //var matchingItems : [PlaceMarkForAllMap] = []
    var mapsViewModels = [MapsViewModel]()
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return matchingItems.count
        return mapsViewModels.count
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
        
        let mapsViewModel = mapsViewModels[indexPath.row]
        myCell.mapsViewModel = mapsViewModel
//        myCell.Title?.text = self.matchingItems[indexPath.row].Name
//        myCell.subTitle?.text = self.matchingItems[indexPath.row].placeName
//            print("\(String(describing: myCell.Title)) ")
        
        return myCell
    }
    
    //MARK: didSelectRowAt
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //API
        //let selectedItem = matchingItems
        //handleMapSearchDelegate?.addAnnotationFromSearch(placeMarks: selectedItem, row: indexPath.row)
        
        let selectedItem = mapsViewModels
        handleMapSearchDelegate?.parseDataFromSearch(viewModel: selectedItem, row: indexPath.row)
        
        dismiss(animated: true, completion: nil)
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

}

extension SearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        activityIndicator.startAnimating()
        
        self.queryService.getData(query: searchController.searchBar.text ?? "", latitude:mapsViewModel.userLocation.latitude, longitude: mapsViewModel.userLocation.longitude )
        
        self.queryService._queryServiceAccess?.parseDataDelegate = self
        
        // MARK: Uncomment this if want to use Closures instead of Delegate (Only MapBox)
//        if let placeMarkx = self.queryService._queryServiceAccess?.fetchData1(query: searchController.searchBar.text ?? "", latitude: mapsViewModel.userLocation.latitude, longitude: mapsViewModel.userLocation.longitude, completion: { [weak self] result in
//           var temp = MapsViewModel(modelAccess: .Google)
//            self?.mapsViewModels = result.map({ return temp.setMapsModel(mapsModelAccess: $0)})
//
//                self?.tableView.reloadData()
//                self?.activityIndicator.stopAnimating()
//
//
//        }) {
//
//        } else{
//            return
//        }
        

      
    }

}

extension SearchTableViewController : ParseDataFromSearch {
    func parseData(data: [PlaceMarkForAllMap]) {
        
       // matchingItems = PlaceMarkForAllMap.shared

        var temp = MapsViewModel(modelAccess: .Google)
        mapsViewModels = data.map({ return temp.setMapsModel(mapsModelAccess: $0)})
        DispatchQueue.main.async{
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    
}
