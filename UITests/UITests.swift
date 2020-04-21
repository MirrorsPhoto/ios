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
        snapshot("0_SignIn")
    }
}
