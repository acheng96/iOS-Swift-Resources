//
//  Event.swift
//  Eventful API Demo
//
//  Created by Annie Cheng on 1/15/16.
//  Copyright © 2016 Annie Cheng. All rights reserved.
//

import Foundation
import UIKit

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

class Event: NSObject {
    
    var eventID: String!
    var eventURL: String!
    var eventTitle: String!
    var eventDescription: String!
    var eventAddress: String!
    var eventTime: String!
    var venue_url: String!
    var venueName: String!
    var imageURL: String!
    
    init(id: String, url: String, title: String, description: String, address: String, time: String, venueURL: String, venueName: String, imageURL: String) {
        self.eventID = id
        self.eventURL = url
        self.eventTitle = title
        self.eventDescription = description
        self.eventAddress = address
        self.eventTime = time
        self.venue_url = venueURL
        self.venueName = venueName
        self.imageURL = imageURL
    }
    
    override var description: String {
        return ("Title: \(eventTitle), Start Time: \(eventTime), Venue Name: \(venueName)")
    }
}