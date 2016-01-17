//
//  ViewController.swift
//  Eventful API Demo
//
//  Created by Annie Cheng on 1/15/16.
//  Copyright © 2016 Annie Cheng. All rights reserved.
//

import UIKit
import SwiftyJSON

struct EventfulAPIStrings {
    
    // Eventful API URL Strings
    static let APIRoot = "http://api.eventful.com/json/events/search?"
    static let APIKey = "app_key=sKJBRSh6NMPR3KDz"
    static let Keyword = "&keywords="
    static let Location = "&location="
    static let Date = "&date="
    static let Category = "&category="
    static let Within = "&within="
    static let Units = "&units="
    static let SortOrder = "&sort_order="
    static let PageSize = "&page_size="
    static let PageNumber = "&page_number="
    
    // Event API Strings
    static let Event: String = "event"
    static let EventID: String = "id"
    static let EventURL: String = "url"
    static let EventTitle: String = "title"
    static let EventDescription: String = "description"
    static let EventStartTime: String = "start_time"
    static let EventStopTime: String = "stop_time"
    static let EventAllDay: String = "all_day"
    
    // Venue API Strings
    static let VenueURL: String = "venue_url"
    static let VenueName: String = "venue_name"
    static let VenueAddress: String = "venue_address"
    static let VenueCity: String = "city_name"
    static let VenueRegion: String = "region_abbr"
    static let VenuePostalCode: String = "postal_code"
    static let Latitude: String = "latitude"
    static let Longitude: String = "longitude"
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variables
    var eventsArray: [Event] = []
    var dateFormatter: NSDateFormatter!
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Store events URL
        let eventsURL = NSURL(string: "http://api.eventful.com/json/events/search?location=New%20York&category=music&date=future&app_key=LBC2sxCN4CpMSXtC")
        getEvents(eventsURL!)
        
        // Set up date formatter
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Set up table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 125.0
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventCell")
    }
    
    // MARK: JSON Parsing Methods
    
    func getEvents(url: NSURL) {
        DataManager.getDataFromURL(url) { (data) -> Void in
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
                
                let longitude = events[i]["longitude"].string ?? ""
                let latitude = events[i]["latitude"].string ?? ""
                
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
                        eventTime = "Please check venue website for time"
                    }
                } else if eventAllDay == "1" { // All day
                    eventTime = "All Day"
                } else { // No time specified
                    eventTime = "Please check venue website for time"
                }
                
                if venueAddress.isEmpty || venueCity.isEmpty || venueRegion.isEmpty {
                    eventAddress = "Please check venue website for address"
                }
                
                let event = Event(id: eventID, url: eventURL, title: eventName, description: eventDescription, address: eventAddress,time: eventTime, venueURL: venueURL, venueName: venueName, imageURL: eventImageURL)
                
//                print("Event ID: \(eventID)")
//                print("Event URL: \(eventURL)")
//                print("Event Name: \(eventName)")
//                print("Event Description: \(eventDescription)")
//                print("Event Address: \(eventAddress)")
//                print("Event Time: \(eventTime)")
//                print("Venue URL: \(venueURL)")
//                print("Venue Name: \(venueName)")
//                print("Longitude: \(longitude)")
//                print("Latitude: \(latitude)")
                
                self.eventsArray.append(event)
            }
            
            self.tableView.reloadData()
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
        
        return cell
    }

}












