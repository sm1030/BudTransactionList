//
//  CacheAPITests.swift
//  BudTransactionListTests
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest
@testable import BudTransactionList

class CacheAPITests: XCTestCase {
    
    var cacheAPI = CacheAPI()
    var imageNotificationExpectation: XCTestExpectation?
    var imageResponse: CacheAPIImageResponse?
    let imageURL = "https://storage.googleapis.com/budcraftstorage/uploads/products/lloyds-bank/Llyods_Favicon-1_161201_091641.jpg"
    let targetSize = CGSize(width: 200, height: 200)
    
    override func setUp() {
        super.setUp()
        
        /// Setup new CacheAPI object
        cacheAPI = CacheAPI()
        cacheAPI.budAPI = BudAPI()
        
        /// Sign up for notifications
        NotificationCenter.default.addObserver(forName: CacheAPI.imageNotification, object: nil, queue: OperationQueue.main) { (notification) in
            if self.imageNotificationExpectation != nil {
                if let imageResponse = notification.object as? CacheAPIImageResponse {
                    if imageResponse.imageURL == self.imageURL && imageResponse.targetSize == self.targetSize {
                        self.imageResponse = imageResponse
                        self.imageNotificationExpectation?.fulfill()
                    }
                }
            }
        }
    }
    
    override func tearDown() {
        /// Unsubscribe from notifications
        NotificationCenter.default.removeObserver(self)
        super.tearDown()
    }
    
    
    func testGetImage() {
        
        /// Test getting image that was not cached yet
        imageNotificationExpectation = XCTestExpectation(description: "imageNotification")
        cacheAPI.budAPI.mockableURLSession.mockMode = .automaticStagingFile
        var image = cacheAPI.getImage(imageURL: imageURL, targetSize: targetSize)
        XCTAssertNil(image)
        if let imageNotificationExpectation = imageNotificationExpectation {
            wait(for: [imageNotificationExpectation], timeout: 3)
            self.imageNotificationExpectation = nil
        }
        XCTAssertNotNil(imageResponse)
        if let imageResponse = self.imageResponse {
            XCTAssertEqual(imageResponse.imageURL, imageURL)
            XCTAssertEqual(imageResponse.image?.size.width, 200)
            XCTAssertEqual(imageResponse.image?.size.height, 200)
        }
        
        /// Now image should be available instantly
        image = cacheAPI.getImage(imageURL: imageURL, targetSize: targetSize)
        XCTAssertNotNil(image)
        if let image = image {
            XCTAssertEqual(image.size.width, 200)
            XCTAssertEqual(image.size.height, 200)
        }
    }
    
    func testRequestImage() {
        
        /// Test requestImage() with BAD imageURL
        var requestImageSeccess = cacheAPI.requestImage(imageURL: "@£$%^&*()", targetSize: targetSize)
        XCTAssertEqual(requestImageSeccess, false)
        
        /// Test nil data
        imageNotificationExpectation = XCTestExpectation(description: "imageNotification")
        let urlResponse = HTTPURLResponse(url: URL(string: "http//test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        cacheAPI.budAPI.mockableURLSession.mockMode = .stagingData(urlResponse: urlResponse, data: nil, error: nil)
        imageResponse = nil
        requestImageSeccess = cacheAPI.requestImage(imageURL: imageURL, targetSize: targetSize)
        XCTAssertEqual(requestImageSeccess, true)
        if requestImageSeccess {
            if let imageNotificationExpectation = imageNotificationExpectation {
                wait(for: [imageNotificationExpectation], timeout: 3)
                self.imageNotificationExpectation = nil
            }
            XCTAssertNotNil(imageResponse)
            if let imageResponse = self.imageResponse {
                XCTAssertEqual(imageResponse.isFromCache, false)
                XCTAssertEqual(imageResponse.imageURL, imageURL)
                XCTAssertEqual(imageResponse.image, nil)
            }
        }
        
        /// Test wrong image data
        imageNotificationExpectation = XCTestExpectation(description: "imageNotification")
        cacheAPI.budAPI.mockableURLSession.mockMode = .stagingData(urlResponse: urlResponse, data: Data(), error: nil)
        requestImageSeccess = cacheAPI.requestImage(imageURL: imageURL, targetSize: targetSize)
        XCTAssertEqual(requestImageSeccess, true)
        if requestImageSeccess {
            if let imageNotificationExpectation = imageNotificationExpectation {
                wait(for: [imageNotificationExpectation], timeout: 3)
                self.imageNotificationExpectation = nil
            }
            XCTAssertNotNil(imageResponse)
            if let imageResponse = self.imageResponse {
                XCTAssertEqual(imageResponse.isFromCache, false)
                XCTAssertEqual(imageResponse.imageURL, imageURL)
                XCTAssertEqual(imageResponse.image, nil)
            }
        }
        
        /// Test getting image that was not cached yet
        imageNotificationExpectation = XCTestExpectation(description: "imageNotification")
        cacheAPI.budAPI.mockableURLSession.mockMode = .automaticStagingFile
        requestImageSeccess = cacheAPI.requestImage(imageURL: imageURL, targetSize: targetSize)
        XCTAssertEqual(requestImageSeccess, true)
        if requestImageSeccess {
            if let imageNotificationExpectation = imageNotificationExpectation {
                wait(for: [imageNotificationExpectation], timeout: 3)
                self.imageNotificationExpectation = nil
            }
            XCTAssertNotNil(imageResponse)
            if let imageResponse = self.imageResponse {
                XCTAssertEqual(imageResponse.isFromCache, false)
                XCTAssertEqual(imageResponse.imageURL, imageURL)
                XCTAssertEqual(imageResponse.image?.size.width, 200)
                XCTAssertEqual(imageResponse.image?.size.height, 200)
            }
        }
        
        /// Now image should be available instantly
        imageNotificationExpectation = XCTestExpectation(description: "imageNotification")
        requestImageSeccess = cacheAPI.requestImage(imageURL: imageURL, targetSize: targetSize)
        XCTAssertEqual(requestImageSeccess, true)
        if requestImageSeccess {
            if let imageNotificationExpectation = imageNotificationExpectation {
                wait(for: [imageNotificationExpectation], timeout: 3)
                self.imageNotificationExpectation = nil
            }
            XCTAssertNotNil(imageResponse)
            if let imageResponse = self.imageResponse {
                XCTAssertEqual(imageResponse.isFromCache, true)
                XCTAssertEqual(imageResponse.imageURL, imageURL)
                XCTAssertEqual(imageResponse.image?.size.width, 200)
                XCTAssertEqual(imageResponse.image?.size.height, 200)
            }
        }
    }
    
    func testPerformanceExample() {
        self.measure {
            /// Now image should be available instantly
            imageNotificationExpectation = XCTestExpectation(description: "imageNotification")
            imageResponse = nil
            let requestImageSeccess = cacheAPI.requestImage(imageURL: imageURL, targetSize: targetSize)
            XCTAssertEqual(requestImageSeccess, true)
            if requestImageSeccess {
                if let imageNotificationExpectation = imageNotificationExpectation {
                    wait(for: [imageNotificationExpectation], timeout: 3)
                    self.imageNotificationExpectation = nil
                }
                XCTAssertNotNil(imageResponse)
                if let imageResponse = self.imageResponse {
                    XCTAssertEqual(imageResponse.imageURL, imageURL)
                    XCTAssertEqual(imageResponse.image?.size.width, 200)
                    XCTAssertEqual(imageResponse.image?.size.height, 200)
                }
            }
        }
    }
    
}
