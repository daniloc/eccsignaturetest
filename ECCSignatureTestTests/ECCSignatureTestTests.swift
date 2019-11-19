//
//  ECCSignatureTestTests.swift
//  ECCSignatureTestTests
//
//  Created by Danilo Campos on 11/19/19.
//  Copyright © 2019 Danilo Campos. All rights reserved.
//

import XCTest
@testable import ECCSignatureTest

class ECCSignatureTestTests: XCTestCase {
    
    var testFile: SignedMessage!

    override func setUp() {
        
        do {
            let path = Bundle.main.path(forResource: "test", ofType: "eccsignaturetest")
            let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
            testFile = try JSONDecoder().decode(SignedMessage.self, from: data)
        } catch {
            XCTAssertNil(error)
        }

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidation() {
        XCTAssertTrue(testFile.validate())
    }
    
    func testContentParsing() {
        XCTAssertTrue(testFile.validate ())
        
        XCTAssertTrue(testFile.originalMessage == "I would like a green chile burrito.")
        
        let dateString = "2019-11-19T20:13:54.705Z"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let date = dateFormatter.date(from: dateString)
        
        XCTAssertTrue(date == testFile.date)
    }

}
