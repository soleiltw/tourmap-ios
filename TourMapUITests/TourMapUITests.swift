//
//  TourMapUITests.swift
//  TourMapUITests
//
//  Created by Edward Chiang on 11/14/15.
//  Copyright © 2015 Soleil Studio. All rights reserved.
//

import XCTest

class TourMapUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        // TODO: Will use this feature later.
//        setupSnapshot(app)
        app.launch()
        
        /*

        Open your Xcode project and make sure to do the following:
        1) Add the ./SnapshotHelper.swift to your UI Test target
        You can move the file anywhere you want
        2) Call `setupSnapshot(app)` when launching your app
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        3) Add `snapshot("0Launch")` to wherever you want to create the screenshots
        
        */

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
