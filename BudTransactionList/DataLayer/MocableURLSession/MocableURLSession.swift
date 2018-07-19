//
//  MocableURLSession.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

/**
 Use this class to Unit Test and UI Test your app.
 You can easily switch between real world http servers and local file based mock up modes.
 */
class MockableURLSession: URLSession {
    
    /// Select appropriate mock mode. By default it is set to "pass through" mode to use real web data.
    var mockMode: URLMockMode = .realWebData
    
    /// Since I can't subclass URLSession, becuse of Init() limitations, I will use local instance instead! ;-)
    let realURLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    /**
     Returns instance of URLSessionDataTask or MockableURLSessionDataTask class depending on mockMode selection
     - parameter with: A URLRequest instance with all request details
     - parameter completionHandler: A completion handler for the dataTask
     */
    override open func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        switch mockMode {
        case .realWebData:
            return realURLSession.dataTask(with: request, completionHandler: completionHandler)
        default:
            return MockableURLSessionDataTask(mockMode: self.mockMode, urlRequest: request, completionHandler: completionHandler)
        }
    }
    
    /**
     Returns instance of URLSessionDataTask or MockableURLSessionDataTask class depending on mockMode selection
     - parameter with: A URL instance with all request details
     - parameter completionHandler: A completion handler for the dataTask
     */
    override open func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        let urlRequest = URLRequest(url: url)
        return self.dataTask(with: urlRequest, completionHandler: completionHandler)
    }
}
