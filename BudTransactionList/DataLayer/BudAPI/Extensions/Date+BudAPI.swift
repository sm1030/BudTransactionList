//
//  Date+BudAPI.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 20/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

extension Date {
    
    /**
     Returns String from self date encoded with Bud format "2014-10-20"
     - returns:  Date string for this date
     */
    var budDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: self)
    }
}
