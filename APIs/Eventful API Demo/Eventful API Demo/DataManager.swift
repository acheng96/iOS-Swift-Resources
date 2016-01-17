//
//  DataManager.swift
//  Eventful API Demo
//
//  Created by Annie Cheng on 1/16/16.
//  Copyright © 2016 Annie Cheng. All rights reserved.
//

import Foundation

class DataManager {
    
    // Get JSON data from a URL String
    class func getDataFromURL(url: NSURL, success: ((JSONData: NSData!) -> Void)) {
        loadDataFromURL(url, completion: { (data: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let urlData = data {
                    success(JSONData: urlData)
                }
            }
        })
    }
    
    // Use NSURLSession to load a data task
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else {
                completion(data: data, error: nil)
            }
        })
        
        dataTask.resume()
    }
    
}