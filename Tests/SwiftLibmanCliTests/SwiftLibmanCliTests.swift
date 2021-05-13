//
//  SwiftLibmanCliTests.swift
//  SwiftLibmanCliTests
//
//  Created by Tibor Bodecs on 2020. 04. 19..
//

import XCTest

final class SwiftLibmanCliTests: XCTestCase {

    var baseUrl: String { "/" + #file.split(separator: "/").dropLast(2).joined(separator: "/") }
 
    // MARK: - test cases

    func testExample() throws {
        XCTAssertTrue(true)
    }
}
