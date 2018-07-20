//
//  BudTransactionListUITests.swift
//  BudTransactionListUITests
//
//  Created by Alexandre Malkov on 19/07/2018.
//  Copyright © 2018 alexmalkov. All rights reserved.
//

import XCTest

class BudTransactionListUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     Since there is not much we can do in this app, except watch the transaction list, I will click on first two cells text lables just to make sure they are present.
     */
    func testTransactionList() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Forbidden planet"]/*[[".cells.staticTexts[\"Forbidden planet\"]",".staticTexts[\"Forbidden planet\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let forbiddenPlanetCellsQuery = tablesQuery.cells.containing(.staticText, identifier:"Forbidden planet")
        forbiddenPlanetCellsQuery.staticTexts["2018-03-19"].tap()
        forbiddenPlanetCellsQuery.staticTexts["13.00 GBP"].tap()
        forbiddenPlanetCellsQuery.staticTexts["Product title:"].tap()
        forbiddenPlanetCellsQuery.staticTexts["Lloyds Bank"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Yamaha music london"]/*[[".cells.staticTexts[\"Yamaha music london\"]",".staticTexts[\"Yamaha music london\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let yamahaMusicLondonCellsQuery = tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Yamaha music london")/*[[".cells.containing(.staticText, identifier:\"14.99 GBP\")",".cells.containing(.staticText, identifier:\"Yamaha music london\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        yamahaMusicLondonCellsQuery.staticTexts["Date:"].tap()
        yamahaMusicLondonCellsQuery.staticTexts["2018-03-19"].tap()
        yamahaMusicLondonCellsQuery.staticTexts["Category:"].tap()
        yamahaMusicLondonCellsQuery.staticTexts["Amount:"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["14.99 GBP"]/*[[".cells.staticTexts[\"14.99 GBP\"]",".staticTexts[\"14.99 GBP\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        yamahaMusicLondonCellsQuery.staticTexts["Product title:"].tap()
        yamahaMusicLondonCellsQuery.staticTexts["Lloyds Bank"].tap()
        
    }
    
}
