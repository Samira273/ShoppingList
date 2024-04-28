//
//  ShoppingListUITests.swift
//  ShoppingListUITests
//
//  Created by Samira Marassy on 24/04/2024.
//

import XCTest
import ShoppingList

final class ShoppingListUITests: XCTestCase {
    var app: XCUIApplication?  = XCUIApplication() // Initializes the XCTest app


    override func setUpWithError() throws {
        continueAfterFailure = false
        guard let app else { return }
        app.launch()
        
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    

    func testAddItem() throws {
        guard let app else { return }
        let addButton = app.buttons["add_button"]
        XCTAssertTrue(addButton.exists)
        addButton.tap()
        let addItemTitleText = app.staticTexts["Add Item"]
        XCTAssertTrue(addItemTitleText.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
