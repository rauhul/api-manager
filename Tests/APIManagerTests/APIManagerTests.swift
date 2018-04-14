import XCTest
@testable import APIManager

class APIManagerTests: XCTestCase {

    func testGetRequest() {
        let complete = expectation(description: "Get request completion")

        TestService.get()
        .onCompletion { (result) in
            switch result {
            case .success(let json, _):
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
        .launch()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPostRequest() {
        let complete = expectation(description: "Post request completion")

        TestService.post()
        .onCompletion { (result) in
            switch result {
            case .success(let json, _):
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
        .launch()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testHeadRequest() {
        let complete = expectation(description: "Head request completion")

        TestService.head()
        .onCompletion { (result) in
            switch result {
            case .success(let data, _):
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
        .launch()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPutRequest() {
        let complete = expectation(description: "Put request completion")

        TestService.put()
        .onCompletion { (result) in
            switch result {
            case .success(let json, _):
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
        .launch()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testDeleteRequest() {
        let complete = expectation(description: "Delete request completion")

        TestService.delete()
        .onCompletion { (result) in
            switch result {
            case .success(let json, _):
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
        .launch()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testOptionsRequest() {
        let complete = expectation(description: "Options request completion")

        TestService.options()
        .onCompletion { (result) in
            switch result {
            case .success(let data, _):
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
        .launch()

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testPatchRequest() {
        let complete = expectation(description: "Patch request completion")

        TestService.patch()
        .onCompletion { (result) in
            switch result {
            case .success(let json, _):
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
        .launch()

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
