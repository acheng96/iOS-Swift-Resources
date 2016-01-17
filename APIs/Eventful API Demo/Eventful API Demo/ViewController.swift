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
        tableView.rowHeight = 90.0
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventCell")
    }
    
    // MARK: JSON Parsing Methods
    
    func getEvents(url: NSURL) {
        DataManager.getDataFromURL(url) { (data) -> Void in
            let json = JSON(data: data)
            
            let eventName = json["events"]["event"][0]["title"].string ?? "Unnamed Event"
            let eventDescription = json["events"]["event"][0]["description"].string ?? "No event description"
            let eventAllDay = json["events"]["event"][0]["all_day"].string ?? ""
            var eventStartTime = json["events"]["event"][0]["start_time"].string ?? ""
            var eventStopTime = json["events"]["event"][0]["stop_time"].string ?? ""
            var eventTime = "\(eventStartTime) - \(eventStopTime)"
            var eventDate = ""
            
            let venueDisplay = json["events"]["event"][0]["venue_display"].string ?? ""
            let venueName = (venueDisplay == "0") ? (json["events"]["event"][0]["venue_name"].string ?? "") : ""
            let venueAddress = json["events"]["event"][0]["venue_address"].string ?? ""
            let venueCity = json["events"]["event"][0]["city_name"].string ?? ""
            let venueRegion = json["events"]["event"][0]["region_abbr"].string ?? ""
            let venuePostalCode = json["events"]["event"][0]["postal_code"].string ?? ""
            var eventAddress = "\(venueAddress), \(venueCity), \(venueRegion) \(venuePostalCode)"
            
            let eventURL = json["events"]["event"][0]["url"].string ?? ""
            let venueURL = json["events"]["event"][0]["venue_url"].string ?? ""
            
            if eventAllDay == "0" { // Start time and stop time as listed
                if !eventStartTime.isEmpty {
                    self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let startDate = self.dateFormatter.dateFromString(eventStartTime)
                    
                    self.dateFormatter.dateFormat = "MMMM dd, yyyy"
                    let startDateString = self.dateFormatter.stringFromDate(startDate!)
                    eventDate = startDateString
                    
                    self.dateFormatter.dateFormat = "h:mm a"
                    let startTimeString = self.dateFormatter.stringFromDate(startDate!)
                    
                    eventStartTime = startTimeString
                }
                
                if !eventStopTime.isEmpty {
                    self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let endDate = self.dateFormatter.dateFromString(eventStopTime)
                    
                    self.dateFormatter.dateFormat = "MMMM dd, yyyy"
                    let endDateString = self.dateFormatter.stringFromDate(endDate!)
                    print("end date: \(endDateString)")
                    
                    self.dateFormatter.dateFormat = "h:mm a"
                    let endTimeString = self.dateFormatter.stringFromDate(endDate!)
                    
                    eventStopTime = endTimeString
                }
                
                if !eventStartTime.isEmpty && eventStopTime.isEmpty {
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

            print("Event Name: \(eventName)")
            print("Event URL: \(eventURL)")
            print("Event Description: \(eventDescription)")
            print("Event Date: \(eventDate)")
            print("Event Time: \(eventTime)")
            print("Venue Name: \(venueName)")
            print("Event Address: \(eventAddress)")
            print("Venue URL: \(venueURL)")
        }
    }
    
    // MARK: Table View Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
        
        return cell
    }

}












