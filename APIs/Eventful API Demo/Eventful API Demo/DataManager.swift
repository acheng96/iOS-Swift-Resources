//
//  DataManager.swift
//  Eventful API Demo
//
//  Created by Annie Cheng on 1/16/16.
//  Copyright © 2016 Annie Cheng. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    
    // MARK: Get Image from URL Methods
    
    class func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    class func downloadImage(url: NSURL, completion: (success: Bool, image: UIImage?) -> Void) {
        getDataFromUrl(url) { (data, response, error)  in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    completion(success: true, image: UIImage(data: data))
                }
            } else {
                completion(success: false, image: nil)
            }
            
        }
    }
    
    // MARK: Get JSON from URL Methods
    
    class func getDataFromURL(url: NSURL, completion: (success: Bool, JSONData: NSData!) -> Void) {
        loadDataFromURL(url, completion: { (data: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let urlData = data {
                    completion(success: true, JSONData: urlData)
                }
            } else {
                completion(success: false, JSONData: nil)
            }
        })
    }
    
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else {
                completion(data: data, error: nil)
            }
        })
        
        dataTask.resume()
    }
    
}