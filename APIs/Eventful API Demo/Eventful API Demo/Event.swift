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
    
    // Event Info
    var eventID: String?
    var eventURL: String?
    var eventTitle: String?
    var eventDescription: String?
    var eventTime: String?
    
    // Venue Info
    var venue_url: String?
    var venueName: String?
    var venueAddress: String?
    
    init(name: String?, url: String?, title: String?, description: String?, eventTime: String?) {
        
    }
    
    override var description: String {
        return ("Title: \(eventTitle), Start Time: \(eventTime), Venue Name: \(venueName)")
    }
}