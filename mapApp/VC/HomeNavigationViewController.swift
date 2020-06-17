//
//  HomeNavigationViewController.swift
//  mapApp
//
//  Created by user on 5/18/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit
import CloudKit

class HomeNavigationViewController: UINavigationController {

    lazy var tableViewController = TableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = CKContainer.default()

              if let containerIdentifier = container.containerIdentifier {
                  print(containerIdentifier)
              }

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "old-map-background.jpg")!)
        
        setupNavBar()
//        configureTableView()
        tableViewController.tableView.frame.origin = CGPoint(x:self.view.frame.maxX/2, y:0)
        tableViewController.tableView.contentSize.height  = self.view.bounds.height/2
        tableViewController.tableView.bounds.size.height = self.view.bounds.height/2
        
        //self.addChild(tableViewController)
        
         pushViewController(tableViewController, animated: true)
        
      
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillLayoutSubviews() {
//        setupNavBar()
//        tableViewController.tableView.frame.origin = CGPoint(x:self.view.frame.maxX/2, y:0)
//        tableViewController.tableView.contentSize.height  = self.view.bounds.height/2
//        tableViewController.tableView.bounds.size.height = self.view.bounds.height/2
//
//        self.addChild(tableViewController)
//
//    }
    
    private func setupNavBar() {
        navigationItem.title = "MapsApp"
        navigationBar.prefersLargeTitles = true
        navigationBar.backgroundColor = UIColor(patternImage: UIImage(named: "old-map-background.jpg")!)
        navigationBar.isTranslucent = true
        
        navigationBar.barTintColor = UIColor.rgb(r: 50, g: 199, b: 242)
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func configureTableView(){
        
       
        self.view.addSubview(tableViewController.tableView)
     
        tableViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDictionary: [String:Any] = ["tableView": tableViewController.tableView!]
        
        let tableView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        let tableView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-333.5-[tableView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        
        view.addConstraints(tableView_H)
        view.addConstraints(tableView_V)
        
         //pushViewController(tableViewController, animated: true)
     
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

extension UIColor {
    static let mainTextBlue = UIColor.rgb(r: 7, g: 71, b: 89)
    static let highlightColor = UIColor.rgb(r: 50, g: 199, b: 242)
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
