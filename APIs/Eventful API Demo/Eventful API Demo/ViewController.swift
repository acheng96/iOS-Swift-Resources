//
//  ViewController.swift
//  Eventful API Demo
//
//  Created by Annie Cheng on 1/15/16.
//  Copyright © 2016 Annie Cheng. All rights reserved.
//

import UIKit

struct EventfulAPIStrings {
    
    // Eventful API URL Strings
    static let EFAPIRoot = "http://api.eventful.com/json/events/search?"
    static let EFAPIKey = "app_key=sKJBRSh6NMPR3KDz"
    static let EFKeywordMethod = "&keywords="
    static let EFLocationMethod = "&location="
    static let EFDateMethod = "&date="
    static let EFCategoryMethod = "&category="
    static let EFWithinMethod = "&within="
    static let EFUnitsMethod = "&units="
    static let EFSortOrderMethod = "&sort_order="
    static let EFPageSizeMethod = "&page_size="
    static let EFPageNumber = "&page_number="
    
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
    var currentEvent: Event!
    var currentString: String = ""
    var storeCharacters: Bool = false
    var dateFormatter: NSDateFormatter!
    var eventsArray: [Event] = []
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up date formatter
        dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Set up table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90.0
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventCell")
    }
    
    // MARK: Helper Functions
    
    func finishedCurrentEvent(event: Event) {
        eventsArray.append(event)
        currentEvent = nil
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












