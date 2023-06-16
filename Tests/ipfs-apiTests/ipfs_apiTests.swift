import XCTest
@testable import ipfs_api

final class ipfs_apiTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ipfs_api().text, "Hello, World!")
    }
}
