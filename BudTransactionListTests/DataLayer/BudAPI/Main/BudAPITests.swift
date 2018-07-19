//
//  BudAPITests.swift
//  BudTransactionListTests
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest
@testable import BudTransactionList

class BudAPITests: XCTestCase {
    
    var budAPI = BudAPI()
    
    override func setUp() {
        super.setUp()
        
        /// Prepare BudAPI
        let budAPI = BudAPI()
        budAPI.printResponseData = true
    }
    
    func testRunDataTaskAndHandleErrors() {
        
        /// Response variables
        var responseData: Data?
        var responseError: Error?
        
        /// Execute query synchronusly
        func executeRunDataTaskAndHandleErrorsSynchronously(urlRequest: URLRequest) {
            let runDataTaskeExpectation = XCTestExpectation(description: "runDataTaskeExpectation")
            budAPI.runDataTaskAndHandleErrors(urlRequest: urlRequest) { (_responseData, _responseError) in
                responseData = _responseData
                responseError = _responseError
                runDataTaskeExpectation.fulfill()
            }
            wait(for: [runDataTaskeExpectation], timeout: 3)
        }
        
        /// Test with response error
        let urlResponse = HTTPURLResponse(url: URL(string: "http//test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        enum TestError: Error { case testError }
        let goodUrlRequest = URLRequest(url: URL(string: "https://www.mocky.io/v2/5b33bdb43200008f0ad1e256")!)
        budAPI.mockableURLSession.mockMode = .stagingData(urlResponse: urlResponse, data: nil, error: TestError.testError)
        executeRunDataTaskAndHandleErrorsSynchronously(urlRequest: goodUrlRequest)
        XCTAssertNil(responseData)
        
        /// Test with wrong response
        let wrongUrlResponse = URLResponse(url: URL(string: "http//test.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        budAPI.mockableURLSession.mockMode = .stagingData(urlResponse: wrongUrlResponse, data: nil, error: nil)
        executeRunDataTaskAndHandleErrorsSynchronously(urlRequest: goodUrlRequest)
        XCTAssertNil(responseData)
        
        /// Test with wrong status code
        let wrongHTTPURLResponse = HTTPURLResponse(url: URL(string: "http//test.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
        budAPI.mockableURLSession.mockMode = .stagingData(urlResponse: wrongHTTPURLResponse, data: nil, error: nil)
        executeRunDataTaskAndHandleErrorsSynchronously(urlRequest: goodUrlRequest)
        XCTAssertNil(responseData)
        
        /// Test with data = nil
        budAPI.mockableURLSession.mockMode = .stagingData(urlResponse: urlResponse, data: nil, error: nil)
        executeRunDataTaskAndHandleErrorsSynchronously(urlRequest: goodUrlRequest)
        XCTAssertNil(responseData)
        
        /// Test SUCCESS
        budAPI.mockableURLSession.mockMode = .automaticStagingFile
        executeRunDataTaskAndHandleErrorsSynchronously(urlRequest: goodUrlRequest)
        XCTAssertNotNil(responseData)
    }
    
    func testDecode() {
        
        /// Test decoding BAD data
        var transactionListResponse: BudAPITransactionListResponse? = budAPI.decode(data: Data())
        XCTAssertNil(transactionListResponse)
        
        /// Test decoding GOOD data
        struct MockableStruct: URLMockable {}
        let mockable = MockableStruct()
        let data = mockable.getData(fileName: "GET_v2_5b33bdb43200008f0ad1e256")
        XCTAssertNotNil(data)
        if let data = data {
            transactionListResponse = budAPI.decode(data: data)
            XCTAssertNotNil(transactionListResponse)
            XCTAssertEqual(transactionListResponse?.data.count, 10)
            if let transactions = transactionListResponse?.data, transactionListResponse?.data.count == 10 {
                let transaction = transactions[0]
                XCTAssertEqual(transaction.id, "13acb877dc4d8030c5dacbde33d3496a2ae3asdc000db4c793bda9c3228baca1a28")
                XCTAssertEqual(transaction.date, "2018-03-19".budDate)
                XCTAssertEqual(transaction.description, "Forbidden planet")
                XCTAssertEqual(transaction.categoryId, 0)
                XCTAssertEqual(transaction.currency, "GBP")
                XCTAssertEqual(transaction.amount?.value, 13)
                XCTAssertEqual(transaction.amount?.currencyIso, "GBP")
                XCTAssertEqual(transaction.product?.id, 4279)
                XCTAssertEqual(transaction.product?.title, "Lloyds Bank")
                XCTAssertEqual(transaction.product?.icon, "https://storage.googleapis.com/budcraftstorage/uploads/products/lloyds-bank/Llyods_Favicon-1_161201_091641.jpg")
            }
        }
    }
}
