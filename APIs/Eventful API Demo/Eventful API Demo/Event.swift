//
//  Event.swift
//  Eventful API Demo
//
//  Created by Annie Cheng on 1/15/16.
//  Copyright © 2016 Annie Cheng. All rights reserved.
//

import Foundation
import UIKit

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