//
//  CacheAPI.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import UIKit

/**
 This class returns web resources stored in the NSCache object. If object is not found in the cache then it download new object and updates the cache. Subscribe for notifications to be notified about rosource arrival.
 */
class CacheAPI {
    
    /// Shared instance
    static let shared = CacheAPI()
    
    /// Notification.Name for the image response  event
    static let imageNotification = Notification.Name("CacheAPI_ImageNotification")
    
    /// This API access web content with BudAPI
    var budAPI = BudAPI.shared
    
    /// Cache for storing images
    var imageCache = NSCache<NSString, UIImage>()
    
}
