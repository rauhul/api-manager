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

        request = TestService.get()
        .onCompletion { (result) in
            switch result {
            case .success(let json):
                let url = json.rawDictionary["url"] as? String
                XCTAssertEqual(url, "https://httpbin.org/get")
                complete.fulfill()

            case .cancellation:
                XCTAssert(false, "Request Cancelled")
                complete.fulfill()

            case .failure(let error):
                XCTAssert(false, error.localizedDescription)
                complete.fulfill()

            }
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPostRequest() {
        let complete = expectation(description: "Post request completion")

        request = TestService.post()
        .onCompletion { (result) in
            switch result {
            case .success(let json):
                let url = json.rawDictionary["url"] as? String
                XCTAssertEqual(url, "https://httpbin.org/post")
                complete.fulfill()

            case .cancellation:
                XCTAssert(false, "Request Cancelled")
                complete.fulfill()

            case .failure(let error):
                XCTAssert(false, error.localizedDescription)
                complete.fulfill()

            }
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testHeadRequest() {
        let complete = expectation(description: "Head request completion")

        request = TestService.head()
        .onCompletion { (result) in
            switch result {
            case .success(let data):
                XCTAssertTrue(data.isEmpty)
                complete.fulfill()

            case .cancellation:
                XCTAssert(false, "Request Cancelled")
                complete.fulfill()

            case .failure(let error):
                XCTAssert(false, error.localizedDescription)
                complete.fulfill()

            }
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPutRequest() {
        let complete = expectation(description: "Put request completion")

        request = TestService.put()
        .onCompletion { (result) in
            switch result {
            case .success(let json):
                let url = json.rawDictionary["url"] as? String
                XCTAssertEqual(url, "https://httpbin.org/put")
                complete.fulfill()

            case .cancellation:
                XCTAssert(false, "Request Cancelled")
                complete.fulfill()

            case .failure(let error):
                XCTAssert(false, error.localizedDescription)
                complete.fulfill()

            }
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testDeleteRequest() {
        let complete = expectation(description: "Delete request completion")

        request = TestService.delete()
        .onCompletion { (result) in
            switch result {
            case .success(let json):
                let url = json.rawDictionary["url"] as? String
                XCTAssertEqual(url, "https://httpbin.org/delete")
                complete.fulfill()

            case .cancellation:
                XCTAssert(false, "Request Cancelled")
                complete.fulfill()

            case .failure(let error):
                XCTAssert(false, error.localizedDescription)
                complete.fulfill()

            }
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testOptionsRequest() {
        let complete = expectation(description: "Options request completion")

        request = TestService.options()
        .onCompletion { (result) in
            switch result {
            case .success(let data):
                XCTAssertTrue(data.isEmpty)
                complete.fulfill()

            case .cancellation:
                XCTAssert(false, "Request Cancelled")
                complete.fulfill()

            case .failure(let error):
                XCTAssert(false, error.localizedDescription)
                complete.fulfill()

            }
        }
        .perform()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPatchRequest() {
        let complete = expectation(description: "Patch request completion")

        request = TestService.patch()
            .onCompletion { (result) in
                switch result {
                case .success(let json):
                    let url = json.rawDictionary["url"] as? String
                    XCTAssertEqual(url, "https://httpbin.org/patch")
                    complete.fulfill()

                case .cancellation:
                    XCTAssert(false, "Request Cancelled")
                    complete.fulfill()

                case .failure(let error):
                    XCTAssert(false, error.localizedDescription)
                    complete.fulfill()

                }
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
