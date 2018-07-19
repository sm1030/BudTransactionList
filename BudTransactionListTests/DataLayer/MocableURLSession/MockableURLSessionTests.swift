//
//  MockableURLSessionTests.swift
//  BudTransactionListTests
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest
@testable import BudTransactionList

class MockableURLSessionTests: XCTestCase {
    
    /// Commonly used variables
    lazy var mockableUrlSession = MockableURLSession()
    lazy var url = URL(string: "https://127.0.0.1/wrong/path?aaa=111")!
    lazy var urlRequest = URLRequest(url: url)
    
    func testDataTask_URLRequest() {
        
        /// Test mockMode = .realWebData
        mockableUrlSession.mockMode = .realWebData
        var dataTask = mockableUrlSession.dataTask(with: urlRequest) { (_, _, _) in }
        XCTAssertNotNil(dataTask)
        XCTAssertEqual(dataTask is MockableURLSessionDataTask, false)
        
        /// Test mockMode != .realWebData
        mockableUrlSession.mockMode = .automaticStagingFile
        dataTask = mockableUrlSession.dataTask(with: urlRequest) { (_, _, _) in }
        XCTAssertNotNil(dataTask)
        XCTAssertEqual(dataTask is MockableURLSessionDataTask, true)
    }
    
    func testDataTask_URL() {
        
        /// Test mockMode = .realWebData
        mockableUrlSession.mockMode = .realWebData
        var dataTask = mockableUrlSession.dataTask(with: url) { (_, _, _) in }
        XCTAssertNotNil(dataTask)
        XCTAssertEqual(dataTask is MockableURLSessionDataTask, false)
        
        /// Test mockMode != .realWebData
        mockableUrlSession.mockMode = .automaticStagingFile
        dataTask = mockableUrlSession.dataTask(with: url) { (_, _, _) in }
        XCTAssertNotNil(dataTask)
        XCTAssertEqual(dataTask is MockableURLSessionDataTask, true)
    }
}
