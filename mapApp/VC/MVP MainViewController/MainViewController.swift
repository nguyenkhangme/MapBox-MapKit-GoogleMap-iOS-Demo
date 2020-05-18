//
//  MainViewController.swift
//  mapApp
//
//  Created by user on 5/18/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit

//MapBox

import MapboxGeocoder
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

//Google

import GoogleMaps

protocol GoToTheMap {
    func show(whatMap: String)
}

class MainViewController: UIViewController {

    lazy var presenter = MainPresenter(with: self)
    
    var type = String()
    
    // MARK: init
    
    lazy var tableViewController = TableViewController()
   
    let activityIndicatorX = UIActivityIndicatorView()
    
    let geocoder = Geocoder.shared
    
    lazy var Mapp = Map(latitude: 40.74699,longtitude: -73.98742,title: "Central Park",subtitle: "The biggest park in New York City!")
    
    lazy var mapView = NavigationMapView(frame: view.bounds)
    
      let googleCamera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    
    lazy var googleMapView = GMSMapView.map(withFrame: self.view.frame, camera: googleCamera)

    
    var directionsRoute: Route?
    
    //MARK: end init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         tableViewController.delegate = self
        // Do any additional setup after loading the view.
        
        configureTableView()
        configureBarButton()
        configureActivityIndicatorX()
        updateView()
    }
    
    func updateView(){
        configureMapBoxx()
        configureBarButton()
        configureGoogleMap()
    }
    
    func configureGoogleMap(){
        if(type=="Google"){
            
            backbutton.isHidden = false;
          
            self.view.addSubview(googleMapView)

            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
            marker.title = "Sydney"
            marker.snippet = "Australia"
            marker.map = googleMapView
            
        }

    }
    
    //VM: VM View Model
    //self.NAvigation.left = UIBArButtonItem(customView: VM.backbutton)
    let backbutton = UIButton(type: .custom)
    func configureBarButton(){
        if(type == "MapBox" || type == "MapKit" || type == "Google") {
            let barButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchPlace))
                   self.navigationItem.rightBarButtonItem = barButton
            
            //Back Button
            
            
            backbutton.setImage(UIImage(named: "BackButton.png"), for: .normal)
            backbutton.setTitle("Back", for: .normal)
            backbutton.setTitleColor(backbutton.tintColor, for: .normal)
            backbutton.addTarget(self, action: #selector(backAction), for: .touchUpInside)

            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        }
       

    }
    @objc func searchPlace(){
    
    }
    @objc func backAction(){
        if(type == "MapBox")
        {
            mapView.removeFromSuperview()
        }else if type == "Google"{
            googleMapView.removeFromSuperview()
        }
        
        backbutton.isHidden = true;
      

    }
    func configureMapBoxx(){
        presenter.configureMapBox(type: type)
    }

    func configureTableView(){
           self.view.addSubview(tableViewController.tableView)
        
        tableViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDictionary: [String:Any] = ["tableView": tableViewController.tableView!]
        
        let tableView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        let tableView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-333.5-[tableView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        view.addConstraints(tableView_H)
        view.addConstraints(tableView_V)
       }
    
    func configureActivityIndicatorX(){
        activityIndicatorX.style = UIActivityIndicatorView.Style.medium

        activityIndicatorX.center = self.view.center

        activityIndicatorX.hidesWhenStopped = true

        self.view.addSubview(activityIndicatorX)
    }

}

extension MainViewController: GoToTheMap {
    func show(whatMap: String) {
        presenter.updateType(whatMap: whatMap)
    }
}

extension MainViewController: PresenterView{
    func updateType(type: String){
        self.type = type
        updateView()
    }
    
    func configureMapBox(){
        
        backbutton.isHidden = false;
        definesPresentationContext = true
               
              mapView.delegate = self
                
              let url = URL(string: "mapbox://styles/mapbox/streets-v11")

              mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
             
              view.addSubview(mapView)
             //mapView.styleURL = MGLStyle.satelliteStyleURL
              mapView.styleURL = url
              

        // Allow the map view to display the user's location
          
              mapView.showsUserLocation = true
              
              mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
    }
}

extension MainViewController: MGLMapViewDelegate {
    
    //Show annotation information
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
         return true
     }

     
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {

     let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 4500, pitch: 15, heading: 180)

     mapView.fly(to: camera, withDuration: 4, peakAltitude: 3000, completionHandler: nil)

     }
}
