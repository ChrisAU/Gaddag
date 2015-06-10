//
//  GaddagTests.swift
//  GaddagTests
//
//  Created by Chris Nevin on 10/06/2015.
//  Copyright (c) 2015 CJNevin. All rights reserved.
//

import UIKit
import XCTest

class GaddagTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGaddag() {
		// This is an example of a functional test case.
		var gaddag = Gaddag()
		gaddag.add("cat")
		gaddag.add("cater")
		gaddag.add("caterpillar")
		gaddag.add("catered")
		// Check to see if a word is defined
		XCTAssert(gaddag.wordDefined("caterpillar"), "Not defined")
		// Find all words which can be made with the current items in our rack
		XCTAssert(gaddag.findWords("", rack: "catered").count == 3, "Count should be 3")
    }
}
