//
//  HomeNavigationViewController.swift
//  mapApp
//
//  Created by user on 5/18/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import UIKit

class HomeNavigationViewController: UINavigationController {

    lazy var tableViewController = TableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "old-map-background.jpg")!)
        
        
//        configureTableView()
        tableViewController.tableView.frame.origin = CGPoint(x:0, y:0)
        tableViewController.tableView.contentSize.height  = self.view.bounds.height/2
        tableViewController.tableView.bounds.size.height = self.view.bounds.height/2
        
        
         pushViewController(tableViewController, animated: true)
        
      
        // Do any additional setup after loading the view.
    }
    
    func configureTableView(){
        
       
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
