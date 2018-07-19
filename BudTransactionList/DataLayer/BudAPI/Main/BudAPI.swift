//
//  BudAPI.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

/**
 Bud API REST methods
 */
enum BudAPIRestMethods: String {
    
    /// Return list of all available products
    case transactionsList = "5b33bdb43200008f0ad1e256"
}

/**
 Bud API Errors
 */
enum BudAPIErrors: Error {
    
    /// Could not get URL string from URLRequest object
    case badUrlObject
    
    /// HTTPURLResponse is NIL
    case httpResponseIsNil
    
    /// StatusCode is not 200
    case statusCodeIsNot200
    
    /// Response data is NIL
    case responseDataIsNil
}

/**
 Swift wrapper for Bud API
 
 This class looks so empty because all it's code lives in extensions located in associated data model files
 */
class BudAPI {
    
    /// Shared instance of BudAPI class
    static let shared = BudAPI()
    
    /// Bud API base URL.
    /// - important: It is **var** for a reason, so you can provide wrong data here to fail some test cases to get better test coverage! :-)
    var apiBase = "https://www.mocky.io/v2/"
    
    /// Change mockMode property to enable/disable data mocking. Really helps with UnitTesting
    var mockableURLSession = MockableURLSession()
    
    /// This will print every incomming responses. It helps with debuging
    var printResponseData: Bool = false
    
    /**
     Run dataTask and handle response.
     - important: Do not call this methid directly. Use BudAPI methods declared in extensions for each data class.
     - important: There are MULTIPLE COMPLETIONS for this method if you set useCoreDataWebResponseCache = true
     - parameter urlRequest: a urlRequest with all necessary BudAPI request data
     - parameter completion: Completion block with preparsed response data.
     */
    func runDataTaskAndHandleErrors(urlRequest: URLRequest, completion: ((Data?, Error?) -> Void)?) {
        
        guard let urlString = urlRequest.url?.absoluteString else {
            print("ERROR: runDataTaskAndHandleErrors(): could not get URL string from URLRequest object")
            completion?(nil, BudAPIErrors.badUrlObject)
            return
        }
        
        /// Log url requested
        print("BudAPI request: \(urlString)")
        
        /// Let's create and run dataTask with provided urlRequest
        let task = mockableURLSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
            
            /// Handle error
            if let error = error {
                print("ERROR: runDataTaskAndHandleErrors() got en error response: \(error)")
                completion?(nil, error)
                return
            }
            
            /// Get HTTPURLResponse
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                print("ERROR: runDataTaskAndHandleErrors() HTTPURLResponse is NIL")
                completion?(nil, BudAPIErrors.httpResponseIsNil)
                return
            }
            
            /// Make sure that response code is 200
            if httpUrlResponse.statusCode != 200 {
                print("ERROR: runDataTaskAndHandleErrors() statusCode = \(httpUrlResponse.statusCode)")
                completion?(nil, BudAPIErrors.statusCodeIsNot200)
                return
            }
            
            /// Make sure that data is not nil
            guard let data = data else {
                print("ERROR: runDataTaskAndHandleErrors() response data is NIL")
                completion?(nil, BudAPIErrors.responseDataIsNil)
                return
            }
            
            /// Print response data if needed
            if self.printResponseData {
                print("DATA JSON: \(String(decoding: data, as: UTF8.self))")
            }
            
            /// Finally we can return data so it will be parsed into specific object by that object method
            completion?(data, nil)
        }
        
        task.resume()
    }
    
    /**
     Decode data into an instance of Decodable class or structuire
     - important: Do not call this methid directly. This is intended to be used by BudAPI methods declared in extensions for each data class.
     - parameter data: Data that needs to be decoded
     - returns: and instance of Decodable class provided to this Generic function
     */
    func decode<T: Decodable>(data: Data) -> T? {
        
        /// Create decoder with iso8601 Date support
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        /// Let's try decode our data
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("ERROR TITLE: \(error.localizedDescription)")
            print("ERROR DETAILS: \(error)")
            print("DATA JSON: \(String(decoding: data, as: UTF8.self))")
            return nil
        }
    }
}
