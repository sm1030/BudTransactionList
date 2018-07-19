//
//  BudTransactionListResponseTests.swift
//  BudTransactionListTests
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest
@testable import BudTransactionList

class BudTransactionListResponseTests: XCTestCase {
    
    func testGetCategories() {
        
        /// Asynchrounus request handler
        var budAPI = BudAPI()
        var transactionListResponse: BudAPITransactionListResponse?
        var responseError: Error?
        func getTransactionListSynchronously() {
            let expectations = XCTestExpectation(description: "getTransactionList")
            budAPI.getTransactionList { (_transactionListResponse, _responseError) in
                transactionListResponse = _transactionListResponse
                responseError = _responseError
                expectations.fulfill()
            }
            wait(for: [expectations], timeout: 3)
        }
        
        /// Test with BAD base API url
        budAPI = BudAPI()
        budAPI.apiBase = "!@£$%^&*()_+"
        budAPI.printResponseData = true
        getTransactionListSynchronously()
        XCTAssertNil(transactionListResponse)
        XCTAssertEqual(responseError?.localizedDescription, BudAPIErrors.badUrlObject.localizedDescription)
        
        /// Test with NIL data
        let urlResponse = HTTPURLResponse(url: URL(string: "http//test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        budAPI = BudAPI()
        budAPI.printResponseData = true
        budAPI.mockableURLSession.mockMode = .stagingData(urlResponse: urlResponse, data: nil, error: nil)
        getTransactionListSynchronously()
        XCTAssertNil(transactionListResponse)
        XCTAssertEqual(responseError?.localizedDescription, BudAPIErrors.responseDataIsNil.localizedDescription)
        
        /// Test with GOOD data
        budAPI = BudAPI()
        budAPI.mockableURLSession.mockMode = .automaticStagingFile
        budAPI.printResponseData = true
        getTransactionListSynchronously()
        XCTAssertNotNil(transactionListResponse)
        XCTAssertEqual(transactionListResponse?.data.count, 10)
        if let transactions = transactionListResponse?.data, transactionListResponse?.data.count == 10 {
            
            if let firstTransaction = transactions.first {
                XCTAssertEqual(firstTransaction.id, "13acb877dc4d8030c5dacbde33d3496a2ae3asdc000db4c793bda9c3228baca1a28")
                XCTAssertEqual(firstTransaction.date, "2018-03-19".budDate)
                XCTAssertEqual(firstTransaction.description, "Forbidden planet")
                XCTAssertEqual(firstTransaction.categoryId, 0)
                XCTAssertEqual(firstTransaction.currency, "GBP")
                XCTAssertEqual(firstTransaction.amount?.value, 13)
                XCTAssertEqual(firstTransaction.amount?.currencyIso, "GBP")
                XCTAssertEqual(firstTransaction.product?.id, 4279)
                XCTAssertEqual(firstTransaction.product?.title, "Lloyds Bank")
                XCTAssertEqual(firstTransaction.product?.icon, "https://storage.googleapis.com/budcraftstorage/uploads/products/lloyds-bank/Llyods_Favicon-1_161201_091641.jpg")
            }
            
            if let lastTransaction = transactions.last {
                XCTAssertEqual(lastTransaction.id, "13acb877dc4d8030c5dacbdewfdge33d3496a2ae3c000db4c793bda9c3228baca1a28")
                XCTAssertEqual(lastTransaction.date, "2018-03-01".budDate)
                XCTAssertEqual(lastTransaction.description, "Dumplings legend")
                XCTAssertEqual(lastTransaction.categoryId, 5)
                XCTAssertEqual(lastTransaction.currency, "GBP")
                XCTAssertEqual(lastTransaction.amount?.value, 77.3)
                XCTAssertEqual(lastTransaction.amount?.currencyIso, "GBP")
                XCTAssertEqual(lastTransaction.product?.id, 4279)
                XCTAssertEqual(lastTransaction.product?.title, "Lloyds Bank")
                XCTAssertEqual(lastTransaction.product?.icon, "https://storage.googleapis.com/budcraftstorage/uploads/products/lloyds-bank/Llyods_Favicon-1_161201_091641.jpg")
            }
        }
    }
}
