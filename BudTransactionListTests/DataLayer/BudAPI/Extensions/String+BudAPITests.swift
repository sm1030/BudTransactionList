//
//  String+BudAPITests.swift
//  BudTransactionListTests
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest
@testable import BudTransactionList

class String_BudAPITests: XCTestCase {
    
    func testBudDate() {
        
        /// Test valid Bud date string
        var date = "2014-10-20".budDate
        XCTAssertEqual(date.debugDescription, "Optional(2014-10-20 00:00:00 +0000)")
        
        /// Test WRONG date string
        date = "asdfg".budDate
        XCTAssertNil(date)
    }
}
