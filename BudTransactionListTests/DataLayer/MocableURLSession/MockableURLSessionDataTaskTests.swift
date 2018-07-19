//
//  MockableURLSessionDataTaskTests.swift
//  BudTransactionListTests
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest
@testable import BudTransactionList

class MockableURLSessionDataTaskTests: XCTestCase {
    
    /// We will use this URL
    let dataURL = "https://www.mocky.io/v2/5b33bdb43200008f0ad1e256"
    
    /// We excpect to map that url to this file name
    let dataFileName = "GET_v2_5b33bdb43200008f0ad1e256"
    
    func testInit() {
        
        /// Init MockableURLSessionDataTask object
        let url = URL(string: dataURL)!
        let urlRequest = URLRequest(url: url)
        let dataTask = MockableURLSessionDataTask(mockMode: .realWebData, urlRequest: urlRequest) { (_, _, _) in }
        
        /// Make sure it is not nil
        XCTAssertNotNil(dataTask)
    }
    
    func testResume() {
        
        /// Variables for completion block handling
        var data: Data?
        var urlResponse: URLResponse?
        var error: Error?
        
        /// Default arguments
        let goodUrlRequest = URLRequest(url: URL(string: dataURL)!)
        let badUrlRequest = URLRequest(url: URL(string: "https://127.0.0.1/wrong/path?aaa=111")!)
        
        /// Let's group asynchrounus call and creation into this method so we can call Synchronously in one line of code
        func createDataTaskAndCallResumeSynchronously(mockMode: URLMockMode, urlRequest: URLRequest?) {
            let expectation = XCTestExpectation(description: "test")
            let dataTask = MockableURLSessionDataTask(mockMode: mockMode, urlRequest: urlRequest) { (_data, _urlResponse, _error) in
                data = _data
                urlResponse = _urlResponse
                error = _error
                expectation.fulfill()
            }
            dataTask.resume()
            wait(for: [expectation], timeout: 333)
        }
        
        /// Testing mockMode = realWebData
        createDataTaskAndCallResumeSynchronously(mockMode: .realWebData, urlRequest: badUrlRequest)
        XCTAssertNil(urlResponse)
        XCTAssertNil(data)
        XCTAssertNil(error)
        
        /// Testing mockMode = automaticStagingFile
        createDataTaskAndCallResumeSynchronously(mockMode: .automaticStagingFile, urlRequest: goodUrlRequest)
        XCTAssertEqual((urlResponse as? HTTPURLResponse)?.statusCode, 200)
        XCTAssertEqual(data?.count,4000)
        XCTAssertNil(error)
        
        /// Testing mockMode = stagingFile
        createDataTaskAndCallResumeSynchronously(mockMode: .stagingFile(fileName: dataFileName), urlRequest: goodUrlRequest)
        XCTAssertEqual((urlResponse as? HTTPURLResponse)?.statusCode, 200)
        XCTAssertEqual(data?.count,4000)
        XCTAssertNil(error)
        
        /// Testing mockMode = stagingFileWithStatusCode
        createDataTaskAndCallResumeSynchronously(mockMode: .stagingFileWithStatusCode(fileName: dataFileName, statusCode: 400), urlRequest: goodUrlRequest)
        XCTAssertEqual((urlResponse as? HTTPURLResponse)?.statusCode, 400)
        XCTAssertEqual(data?.count,4000)
        XCTAssertNil(error)
        
        /// Testing mockMode = stagingData
        enum TestErrors: Error { case testError }
        let testError = TestErrors.testError
        let testData = Data()
        let testURLResponse = HTTPURLResponse(url: goodUrlRequest.url!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        createDataTaskAndCallResumeSynchronously(mockMode: .stagingData(urlResponse: testURLResponse, data: testData, error: testError), urlRequest: goodUrlRequest)
        XCTAssertEqual(data, testData)
        XCTAssertEqual(error?.localizedDescription, testError.localizedDescription)
        XCTAssertEqual(urlResponse, testURLResponse)
    }
    
    
}
