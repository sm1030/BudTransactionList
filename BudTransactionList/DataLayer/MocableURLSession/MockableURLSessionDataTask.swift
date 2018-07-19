//
//  MockableURLSessionDataTask.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

/**
 URLSessionDataTask that implements web data mocking
 */
class MockableURLSessionDataTask: URLSessionDataTask, URLMockable {
    
    /// Private vars initialized by convinience Init method
    private var urlRequest: URLRequest?
    private var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    private var mockMode: URLMockMode = .realWebData
    
    /**
     Initialization method for the MockableURLSessionDataTask
     - parameter mockMode: A URLMockMode provided by the MockableURLSession
     - parameter urlRequest: A URLRequest provided by the MockableURLSession
     - parameter completionHandler: A completionHandler provided by end user class
     */
    init(mockMode: URLMockMode, urlRequest: URLRequest?, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        self.mockMode = mockMode
        self.urlRequest = urlRequest
        self.completionHandler = completionHandler
    }
    
    /**
     This methods pretend performing web request and returns mock data depending selected on MockMode
     */
    override func resume() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1, execute: {
            
            var responseData: Data?
            var responseURL: URLResponse?
            var responseError: Error?
            
            switch self.mockMode {
            case .automaticStagingFile:
                let fileName = self.getStagingFileName(urlRequest: self.urlRequest)
                responseURL = HTTPURLResponse(url: (self.urlRequest?.url)!, statusCode: 200, httpVersion: nil, headerFields: nil)
                responseData = self.getData(fileName: fileName)
            case .stagingFile(let fileName):
                responseURL = HTTPURLResponse(url: (self.urlRequest?.url)!, statusCode: 200, httpVersion: nil, headerFields: nil)
                responseData = self.getData(fileName: fileName)
            case .stagingFileWithStatusCode(let fileName, let statusCode):
                responseURL = HTTPURLResponse(url: (self.urlRequest?.url)!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
                responseData = self.getData(fileName: fileName)
            case .stagingData(let urlResponse, let data, let error):
                responseURL = urlResponse
                responseData = data
                responseError = error
            default:
                break
            }
            self.completionHandler?(responseData,responseURL,responseError)
        })
    }
}
