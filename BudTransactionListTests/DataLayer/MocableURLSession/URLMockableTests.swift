//
//  URLMockableTests.swift
//  BudTransactionListTests
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest
@testable import BudTransactionList

class URLMockableTests: XCTestCase {
    
    /// This is how we will instantiate our protocol! :-)
    struct MockableStruct: URLMockable {}
    let mockable = MockableStruct()
    
    /// We will use this URL
    let dataUrlString = "https://www.mocky.io/v2/5b33bdb43200008f0ad1e256"
    
    /// We excpect to map that url to this file name
    let dataFileName = "GET_v2_5b33bdb43200008f0ad1e256"
    
    /// We will also use this image
    let imageFileName = "GET_budcraftstorage_uploads_products_lloyds-bank_Llyods_Favicon-1_161201_091641.jpg"
    
    func testGetStagingFileName() {
        
        /// Test WITHOUT query string
        var urlRequest = URLRequest(url: URL(string: dataUrlString)!)
        var fileName = mockable.getStagingFileName(urlRequest: urlRequest)
        XCTAssertEqual(fileName, dataFileName)
        
        /// Test WITH query string
        urlRequest = URLRequest(url: URL(string: dataUrlString)!)
        fileName = mockable.getStagingFileName(urlRequest: urlRequest)
        XCTAssertEqual(fileName, dataFileName)
        
        /// Test with urlRequest = nil
        fileName = mockable.getStagingFileName(urlRequest: nil)
        XCTAssertEqual(fileName, nil)
    }
    
    func testGetData() {
        
        /// Test getData() from file with nil name
        var data = mockable.getData(fileName: nil)
        XCTAssertNil(data)
        
        /// Test getData() from file with "" name
        data = mockable.getData(fileName: "")
        XCTAssertNil(data)
        
        /// Test getData() from file with "xxx" name
        data = mockable.getData(fileName: "xxx")
        XCTAssertNil(data)
        
        /// Test getData() from file with GOOD JSON content
        data = mockable.getData(fileName: dataFileName)
        XCTAssertNotNil(data)
        
        /// Test getData() from file with GOOD JPEG content
        data = mockable.getData(fileName: imageFileName)
        XCTAssertNotNil(data)
    }
}
