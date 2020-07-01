import XCTest
@testable import Abacus

final class AbacusTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Abacus().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
