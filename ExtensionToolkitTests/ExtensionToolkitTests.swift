//
//  ExtensionToolkitTests.swift
//  ExtensionToolkitTests
//
//  Created by Trainee on 12/03/2018.
//  Copyright © 2018 Trainee. All rights reserved.
//

import XCTest
@testable import ExtensionToolkit

class ExtensionToolkitTests: XCTestCase {
    
    func testParseHMS() {
        let testing = Int.parseHMS(hms: "01:01:01")
        XCTAssert(testing == 3661, "Could not parse string to seconds")
    }
    
}
