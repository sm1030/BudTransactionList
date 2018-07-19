//
//  String+BudAPI.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

extension String {
    
    /**
     Returns Date from self string encoded with BudAPI format "2014-10-20"
     - important: Date string must be formated as "2014-10-20"
     - returns:  Date value for this string
     */
    var budDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from:self)
    }
    
}
