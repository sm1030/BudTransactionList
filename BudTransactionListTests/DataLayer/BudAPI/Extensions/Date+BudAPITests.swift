//
//  Date+BudAPITests.swift
//  BudTransactionListTests
//
//  Created by Alexandre Malkov on 20/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest
@testable import BudTransactionList

class Date_BudAPITests: XCTestCase {
    
    func testYouTubeDateString() {
        let originalDateString = "2014-10-20"
        let date = originalDateString.budDate
        let finalDateString = date?.budDateString
        XCTAssertEqual(finalDateString, originalDateString)
    }
    
}
