//
//  ViewController.swift
//  Eventful API Demo
//
//  Created by Annie Cheng on 1/15/16.
//  Copyright © 2016 Annie Cheng. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    // Variables
    var locationManager: CLLocationManager!
    var categories: [String] = []
    var categoryIDs: [String] = []
    var userLocationCoordinate: String!
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        // Get user's location
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        // Set up table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        
        loadCategories()
    }
    
    func loadCategories() {
        let rootURL = EventfulAPIStrings.CategoriesAPIRoot
        let appKey = EventfulAPIStrings.AppKey
        let categoriesURL = NSURL(string: rootURL + appKey)
        
        getCategories(categoriesURL!)
    }
    
    // MARK: User Location Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationCoordinate: CLLocationCoordinate2D = manager.location!.coordinate
        userLocationCoordinate = "\(locationCoordinate.latitude),\(locationCoordinate.longitude)"
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: JSON Parsing Methods
    
    func getCategories(url: NSURL) {
        DataManager.getDataFromURL(url) { (data) -> Void in
            let json = JSON(data: data)
            let categories = json["category"]
            
            for (var i = 0; i < categories.count; i++) {
                let categoryName = categories[i]["name"].string ?? ""
                let editedCategoryName = categoryName.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
                let categoryID = categories[i]["id"].string ?? ""
                self.categories.append(editedCategoryName)
                self.categoryIDs.append(categoryID)
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: Table View Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryTableViewCell
        
        cell.categoryNameLabel.text = categories[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        performSegueWithIdentifier("goToEventsVC", sender: cell)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? CategoryTableViewCell {
            let indexPath = tableView.indexPathForCell(cell)
            
            if segue.identifier == "goToEventsVC" {
                let eventsVC = segue.destinationViewController as! EventsViewController
                eventsVC.category = cell.categoryNameLabel.text
                eventsVC.categoryID = categoryIDs[indexPath!.row]
                eventsVC.userLocationCoordinate = userLocationCoordinate
            }
        }
    }

}












