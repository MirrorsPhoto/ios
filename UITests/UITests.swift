//
//  UITests.swift
//  UITests
//
//  Created by Сергей Прищенко on 20.04.2020.
//  Copyright © 2020 Mirror's Photo. All rights reserved.
//

import XCTest

class UITests: XCTestCase {
    
   override func setUp() {
        super.setUp()
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testExample() throws {
        let app = XCUIApplication()

        snapshot("00_SignIn")

        let loginField = app.textFields["login"]
        loginField.tap()
        app.keys["b"].tap()
        app.keys["o"].tap()
        app.keys["o"].tap()
        app.keys["l"].tap()
        app.keys["e"].tap()
        app.keys["a"].tap()
        app.keys["n"].tap()

        let passwordField = app.secureTextFields["password"]
        passwordField.tap()
        app.keys["d"].tap()
        app.keys["e"].tap()
        app.keys["v"].tap()
        app.keys["p"].tap()
        app.keys["a"].tap()
        app.keys["s"].tap()
        app.keys["s"].tap()

        app.buttons["Return"].tap()
        app.buttons["sign_in"].tap()
        sleep(5)

        snapshot("01_Dashboard")
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(3)

        snapshot("02_Goods")
        
        app.tabBars.buttons.element(boundBy: 2).tap()

        snapshot("03_Profile")
    }
}
