//
//  APIRequest.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

import Foundation

/// Enumeration of the Errors that can occur during an APIRequest.
public enum APIRequestError: Error {
    /// occurs when an APIRequest gets a response with an invalid response code, additionally provides a decription of the error code
    case invalidHTTPReponse(code: Int, description: String)

    /// occurs when an APIRequest encounters an inconsistancy it does not know how to handle, additionally provides a decription of the error
    case internalError(description: String)
}


/// Base class for creating APIRequests.
/// - note: `APIRequests` should be created through a class that conforms to `APIService`.
open class APIRequest<ReturnType: APIReturnable> {

    // MARK: - Types & Aliases
    /// Alias for the callback when an `APIRequest` succeeds, called with the json response.
    public typealias Success = (_ returnValue: ReturnType) -> Void

    /// Alias for the callback when a `APIRequest` fails, called with the error description.
    public typealias Failure = (_ error: Error) -> Void

    /// Alias for the callback when an `APIRequest` is cancelled. No additional data is provided.
    public typealias Cancellation = () -> Void

    // MARK: - Required Properties
    /// The endpoint for the HTTP Request relative to the baseURL of the `service`.
    open private(set) var endpoint: String

    /// The method for the HTTP Request.
    open private(set) var method: HTTPMethod

    // MARK: - Generics
    /// TODO: Document
    open private(set) var service: APIService.Type

    // MARK: - Optional Properties
    /// The url parameters for the HTTP Request.
    open private(set) var params: HTTPParameters?

    /// The json body for the HTTP Request.
    open private(set) var body: HTTPBody?

    /// The object used to authorize the request.
    open private(set) var authorization: APIAuthorization?

    // MARK: - Callbacks
    /// The callback on a successful `APIRequest`, called with the an object of the ReturnType.
    open private(set) var success: Success?

    /// The callback on a failed `APIRequest`, called with the error.
    open private(set) var failure: Failure?

    /// The callback on a cancelled `APIRequest`.
    open private(set) var cancellation: Cancellation?

    /// The callback for the `URLRequest` used to make the `APIRequest`
    private func urlRequestCallback(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            if (error as NSError).code == NSURLErrorCancelled {
                cancellation?()
            } else {
                failure?(error)
            }
        } else if let response = response as? HTTPURLResponse, let data = data {
            do {
                try service.validate(statusCode: response.statusCode)
                let returnValue = try ReturnType(from: data)
                success?(returnValue)
            } catch {
                failure?(error)
            }
        } else {
            failure?(APIRequestError.internalError(description: "Unable parse returned data."))
        }
    }

    // MARK: - Generators
    /// Creates the `APIRequest` to a URLRequest to be used in a URLSession.
    private func urlRequest() -> URLRequest {
        // add authorization into the HTTPParameters or HTTPBody as needed
        let (paramaters, body) = authorization?.embedInto(request: self) ?? (self.params, self.body)

        let url = URL(base: service.baseURL + endpoint, paramaters: paramaters)!

        #if DEBUG
            print("🚀", method.rawValue, url.absoluteString)
        #endif

        return URLRequest(url: url, method: method, body: body, headers: service.headers)
    }

    // MARK: - Init
    /// Creates a new APIRequest.
    /// - parameters:
    ///     - endpoint:     The api endpoint relative to the baseURL of the APIService.
    ///     - queryParams:  The url parameters for the HTTP Request.
    ///     - body:         An optional json body for the HTTP Request.
    ///     - method:       The method for the HTTP Request.
    /// - note: Only to be used by a class that conforms to APIService
    public init(service: APIService.Type, endpoint: String, params: HTTPParameters? = nil, body: HTTPBody? = nil, method: HTTPMethod) {
        self.endpoint = endpoint
        self.body = body
        self.params = params
        self.method = method
        self.service = service

        print("request init")
    }

    deinit {
        print("request deinit")
    }

    // MARK: - Setters
    /// Sets the callback on a successful `APIRequest`, called with the an object of the ReturnType.
    /// - parameters:
    ///     - success: The block to be called on a successful request.
    /// - returns: `self` for method chaining as need
    @discardableResult
    open func onSuccess(_ success: Success?) -> APIRequest {
        self.success = success
        return self
    }

    /// Sets the callback on a failed `APIRequest`, called with the error.
    /// - parameters:
    ///     - failure: The block to be called on a failed request.
    /// - returns: `self` for method chaining as need
    @discardableResult
    open func onFailure(_ failure: Failure?) -> APIRequest {
        self.failure = failure
        return self
    }

    /// Sets the callback on a cancelled `APIRequest`.
    /// - parameters:
    ///     - cancellation: The block to be called on a cancelled request.
    /// - returns: `self` for method chaining as need
    @discardableResult
    open func onCancellation(_ cancellation: Cancellation?) -> APIRequest {
        self.cancellation = cancellation
        return self
    }

    /// Sets the authorization for an `APIRequest`.
    /// - parameters:
    ///     - authorization: The object used to authorize the request.
    /// - returns: `self` for method chaining as need
    @discardableResult
    open func authorization(_ authorization: APIAuthorization?) -> APIRequest {
        self.authorization = authorization
        return self
    }

    /// Performs the APIRequest. On a successful request the `success` closure will be called with the an object of the ReturnType. On a failed request the `failure` closure will be called with the error. On a cancelled request the `cancellation` closure will be called.
    @discardableResult
    open func perform() -> APIRequestToken {
        let task = URLSession.shared.dataTask(with: urlRequest(), completionHandler: urlRequestCallback)
        task.resume()
        return APIRequestToken(task: task)
    }

}


public enum APIRequestState {
    case running
    case completed
}

open class APIRequestToken {

    // MARK: - Properties
    open var state: APIRequestState {
        return task.state == .completed ? .completed : .running
    }

    // MARK: - Private Properties

    /// `URLSessionDataTask` backing the APIRequest
    private var task: URLSessionDataTask
    private var retain: Unmanaged<APIRequestToken>?
    private var observation: NSKeyValueObservation?

    public init(task: URLSessionDataTask) {
        self.task = task
        observation = task.observe(\.state) { [weak self] (task, change) in
            switch task.state {
            case .completed:
                self?.retain?.release()
                self?.observation?.invalidate()
            default:
                break
            }
        }
        retain = Unmanaged.passRetained(self)

        print("token init")
    }

    deinit {
        print("token deinit")
    }

    // MARK: - API
    /// Cancels the `APIRequest` represented by this token
    open func cancel() {
        task.cancel()
    }
}


