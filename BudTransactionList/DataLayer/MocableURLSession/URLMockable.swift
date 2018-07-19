//
//  URLMockable.swift
//  BudTransactionList
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import Foundation

/**
 Mocing modes used by the URLMockable protocol
 */
enum URLMockMode {
    
    /// Pass through mode when staging data not in use. You will get real web server data. This is Default option.
    case realWebData
    
    /// "Web" response comes from staging files. File name calculated automatically based on URL Path and URL Query
    case automaticStagingFile
    
    /// "Web" response comes from file with specified name. Status code set tpo 200
    case stagingFile(fileName: String?)
    
    /// "Web" response comes from file with specified name and specific status code
    case stagingFileWithStatusCode(fileName: String?, statusCode: Int)
    
    /// Getting response data directly from arguments
    case stagingData(urlResponse: URLResponse, data: Data?, error: Error?)
}

/**
 Declaration of the URLMocable protocol
 */
protocol URLMockable {
    
    /**
     Construct staging file name based on HTTP method, Base URL and query arguments
     - parameter urlRequest: instance of URLRequest with all needed information
     - returns: File name with staged JSON data
     */
    func getStagingFileName(urlRequest: URLRequest?) -> String?
    
    /**
     Read JSON file from app resources
     - parameter fileName: JSON file name
     - returns: data object with JSON file content
     */
    func getData(fileName: String?) -> Data?
}

/**
 Implementation for the URLMocable protocol
 */
extension URLMockable {
    
    /**
     Construct staging file name based on HTTP method, Base URL and query arguments
     - parameter urlRequest: instance of URLRequest with all needed information
     - returns: File name with staged JSON data
     */
    func getStagingFileName(urlRequest: URLRequest?) -> String? {
        
        if
            let urlRequest = urlRequest,
            let url = urlRequest.url
        {
            
            /// Get HTTP method
            let httpMethod = urlRequest.httpMethod ?? ""
            
            /// Get path
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let originalPath = urlComponents?.path ?? ""
            let formatedPath = originalPath.replacingOccurrences(of: "/", with: "_")
            
            /// Get arguments string
            var joinedtems = ""
            if let query = url.query {
                let allItems = query.components(separatedBy: "&")
                let filteredItems = allItems.filter(){ !$0.starts(with: "key=") }
                let soretedItems = filteredItems.sorted()
                joinedtems = "?" + soretedItems.joined(separator: "&")
            }
            
            /// Return
            let fileName = "\(httpMethod)\(formatedPath)\(joinedtems)"
            return fileName
        }
        
        return nil
    }
    
    /**
     Read JSON file from app resources
     - parameter fileName: JSON file name
     - returns: data object with JSON file content
     */
    func getData(fileName: String?) -> Data? {
        
        /// Make sure fileName is not nil
        guard let fileName = fileName else {
            print("ERROR: getData() can't access file with fileName = nil")
            return nil
        }
        
        /// Make sure fileName is not ""
        guard fileName != "" else {
            print("ERROR: getData() can't access file with fileName = \"\"")
            return nil
        }
        
        /// Make sure resource with fileName actually exists
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: "") else {
            print("ERROR: getData() can't find file with fileName = \"\(fileName)\"")
            return nil
        }
        
        /// Try to read data from file
        do {
            if fileName.hasSuffix(".jpg") {
                let fileHandle = FileHandle(forReadingAtPath: filepath)
                let data = fileHandle?.readDataToEndOfFile()
                fileHandle?.closeFile()
                return data
            } else {
                let jsonString = try String(contentsOfFile: filepath)
                return jsonString.data(using: .utf8)
            }
        } catch {
            print("ERROR: \(error)")
            return nil
        }
    }
}
