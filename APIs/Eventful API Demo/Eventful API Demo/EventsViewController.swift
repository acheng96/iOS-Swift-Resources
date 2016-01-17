//
//  EventsViewController.swift
//  Eventful API Demo
//
//  Created by Annie Cheng on 1/17/16.
//  Copyright © 2016 Annie Cheng. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    var category: String!
    var categoryID: String!
    var eventsArray: [Event] = []
    var dateFormatter: NSDateFormatter!
    var numMilesRadius: Int = 20
    var userLocationCoordinate: String!
    var eventsPageNumber: Int = 1
    var eventsPageSize: Int = 10
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        navigationItem.title = category
        
        // Set up loading view
        loadingView.layer.cornerRadius = 10
        loadingView.layer.masksToBounds = true
        loadingView.hidden = false
        activityIndicator.startAnimating()
        
        // Set up date formatter
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Set up table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 125.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        
        loadEvents()
    }
    
    // MARK: JSON Parsing Methods
    
    func loadEvents() {
        let rootURL = EventfulAPIStrings.EventsAPIRoot
        let appKey = EventfulAPIStrings.AppKey
        let location = EventfulAPIStrings.Location + userLocationCoordinate
        let date = EventfulAPIStrings.Date + "future"
        let sortOrder = EventfulAPIStrings.SortOrder + "date"
        let category = EventfulAPIStrings.Category + categoryID
        let within = EventfulAPIStrings.Within + String(numMilesRadius)
        let pageSize = EventfulAPIStrings.PageSize + String(eventsPageSize)
        let pageNumber = EventfulAPIStrings.PageNumber + String(eventsPageNumber)
        let eventsURL = NSURL(string: rootURL + appKey + location + date + sortOrder + category + within + pageSize + pageNumber)
        
        getEvents(eventsURL!) { (finished) -> Void in
            if finished {
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadingView.hidden = true
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func getEvents(url: NSURL, completion: (finished: Bool) -> Void) {
        DataManager.getDataFromURL(url) { (success, data) -> Void in
            let json = JSON(data: data)
            let events = json["events"]["event"]
            
            for (var i = 0; i < events.count; i++) {
                let eventID = events[i]["id"].string ?? ""
                let eventURL = events[i]["url"].string ?? ""
                let eventName = events[i]["title"].string ?? "Unnamed Event"
                let eventDescription = events[i]["description"].string ?? "No event description"
                let eventAllDay = events[i]["all_day"].string ?? ""
                var eventStartTime = events[i]["start_time"].string ?? ""
                var eventStopTime = events[i]["stop_time"].string ?? ""
                var eventTime = ""
                let eventImageURL = events[i]["image"]["url"].string ?? ""
                
                let venueURL = events[i]["venue_url"].string ?? ""
                let venueDisplay = events[i]["venue_display"].string ?? ""
                let venueName = (venueDisplay == "0") ? (events[i]["venue_name"].string ?? "") : ""
                let venueAddress = events[i]["venue_address"].string ?? ""
                let venueCity = events[i]["city_name"].string ?? ""
                let venueRegion = events[i]["region_abbr"].string ?? ""
                let venuePostalCode = events[i]["postal_code"].string ?? ""
                var eventAddress = "\(venueAddress), \(venueCity), \(venueRegion) \(venuePostalCode)"
                
                let latitude = events[i]["latitude"].string ?? ""
                let longitude = events[i]["longitude"].string ?? ""
                let geocoordinates = "\(latitude), \(longitude)"
                
                if eventAllDay == "0" { // Start time and stop time as listed
                    if !eventStartTime.isEmpty {
                        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let startDate = self.dateFormatter.dateFromString(eventStartTime)
                        
                        self.dateFormatter.dateFormat = "h:mm a E, MMM dd, yyyy"
                        eventStartTime = self.dateFormatter.stringFromDate(startDate!)
                    }
                    
                    if !eventStopTime.isEmpty {
                        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let endDate = self.dateFormatter.dateFromString(eventStopTime)
                        
                        self.dateFormatter.dateFormat = "h:mm a E, MMM dd, yyyy"
                        eventStopTime = self.dateFormatter.stringFromDate(endDate!)
                    }
                    
                    if (!eventStartTime.isEmpty && !eventStopTime.isEmpty) {
                        eventTime = "from \(eventStartTime) to \(eventStopTime)"
                    } else if (!eventStartTime.isEmpty && eventStopTime.isEmpty) {
                        eventTime = "Starts \(eventStartTime)"
                    } else if (eventStartTime.isEmpty && eventStopTime.isEmpty) {
                        eventTime = "Please check event website for time"
                    }
                } else if eventAllDay == "1" { // All day
                    eventTime = "All Day"
                } else { // No time specified
                    eventTime = "Please check event website for time"
                }
                
                if venueAddress.isEmpty || venueCity.isEmpty || venueRegion.isEmpty {
                    eventAddress = "Please check venue website for address"
                }
                
                let event = Event(id: eventID, url: eventURL, title: eventName, description: eventDescription, address: eventAddress,time: eventTime, venueURL: venueURL, venueName: venueName, imageURL: eventImageURL, geocoordinates: geocoordinates)
                
                self.eventsArray.append(event)
            }
            
            completion(finished: true)
        }
    }
    
    // MARK: Table View Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
        
        let imageURL = eventsArray[indexPath.row].imageURL
        
        if imageURL != "" {
            DataManager.downloadImage(NSURL(string: imageURL)!, completion: { (success: Bool, image: UIImage?) -> Void in
                if success {
                    if let eventImage = image {
                        cell.eventImageView.image = eventImage
                    }
                }
            })
        }
        
        cell.eventNameLabel.text = eventsArray[indexPath.row].eventTitle
        cell.eventAddressLabel.text = eventsArray[indexPath.row].eventAddress
        cell.dateLabel.text = eventsArray[indexPath.row].eventTime
        
        if indexPath.row == ((eventsPageSize * eventsPageNumber) - 5) {
            eventsPageNumber++
            loadEvents()
        }
        
        return cell
    }
}
