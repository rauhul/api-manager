import XCTest
@testable import APIManager

class APIManagerTests: XCTestCase {

    var request: APIRequestToken?

    override func tearDown() {
        request = nil
        super.tearDown()
    }

    func testGetRequest() {
        let complete = expectation(description: "Get request completion")

        TestService.get()
        .onSuccess { (json) in
            let url = json.rawDictionary["url"] as? String
            XCTAssertEqual(url, "https://httpbin.org/get")
            complete.fulfill()
        }
        .onFailure { (error) in
            XCTAssert(false, error.localizedDescription)
            complete.fulfill()
        }
        .onCancellation {
            XCTAssert(false, "Request Cancelled")
            complete.fulfill()
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPostRequest() {
        let complete = expectation(description: "Post request completion")

        request = TestService.post()
        .onSuccess { (json) in
            let url = json.rawDictionary["url"] as? String
            XCTAssertEqual(url, "https://httpbin.org/post")
            complete.fulfill()
        }
        .onFailure { (error) in
            XCTAssert(false, error.localizedDescription)
            complete.fulfill()
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testHeadRequest() {
        let complete = expectation(description: "Head request completion")

        request = TestService.head()
        .onSuccess { (data) in
            XCTAssertTrue(data.isEmpty)
            complete.fulfill()
        }
        .onFailure { (error) in
            XCTAssert(false, error.localizedDescription)
            complete.fulfill()
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPutRequest() {
        let complete = expectation(description: "Put request completion")

        request = TestService.put()
        .onSuccess { (json) in
            let url = json.rawDictionary["url"] as? String
            XCTAssertEqual(url, "https://httpbin.org/put")
            complete.fulfill()
        }
        .onFailure { (error) in
            XCTAssert(false, error.localizedDescription)
            complete.fulfill()
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testDeleteRequest() {
        let complete = expectation(description: "Delete request completion")

        request = TestService.delete()
        .onSuccess { (json) in
            let url = json.rawDictionary["url"] as? String
            XCTAssertEqual(url, "https://httpbin.org/delete")
            complete.fulfill()
        }
        .onFailure { (error) in
            XCTAssert(false, error.localizedDescription)
            complete.fulfill()
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testOptionsRequest() {
        let complete = expectation(description: "Options request completion")

        request = TestService.options()
        .onSuccess { (data) in
            XCTAssertTrue(data.isEmpty)
            complete.fulfill()
        }
        .onFailure { (error) in
            XCTAssert(false, error.localizedDescription)
            complete.fulfill()
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPatchRequest() {
        let complete = expectation(description: "Patch request completion")

        request = TestService.patch()
        .onSuccess { (json) in
            let url = json.rawDictionary["url"] as? String
            XCTAssertEqual(url, "https://httpbin.org/patch")
            complete.fulfill()
        }
        .onFailure { (error) in
            XCTAssert(false, error.localizedDescription)
            complete.fulfill()
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    static var allTests = [
        ("Test GET Request", testGetRequest),
        ("Test POST Request", testPostRequest),
        ("Test HEAD Request", testHeadRequest),
        ("Test PUT Request", testPutRequest),
        ("Test Delete Request", testDeleteRequest),
        ("Test OPTIONS Request", testOptionsRequest),
        ("Test PATCH Request", testPatchRequest)
    ]

}
