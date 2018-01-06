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

/**
    Base class for creating APIRequests.

    - note: `APIRequests` should be created through a class that conforms to `APIService`.
 */
open class APIRequest<ReturnType: APIReturnable> {
    // MARK: - Types & Aliases
    /// Enumeration of the HTTP methods supported by APIRequest.
    public enum HTTPMethod: String {
        /// The GET method requests a representation of the specified resource. Requests using GET should only retrieve data.
        case GET

        /// The HEAD method asks for a response identical to that of a GET request, but without the response body.
        case HEAD

        /// The POST method is used to submit an entity to the specified resource, often causing a change in state or side effects on the server.
        case POST

        /// The PUT method replaces all current representations of the target resource with the request payload.
        case PUT

        /// The DELETE method deletes the specified resource.
        case DELETE

        /// The OPTIONS method is used to describe the communication options for the target resource.
        case OPTIONS

        /// The PATCH method is used to apply partial modifications to a resource.
        case PATCH
    }

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
    private lazy var urlRequestCallback: (Data?, URLResponse?, Error?) -> Void = { [weak self] (data, response, error) in
        defer {
            self?.unmanaged = nil
        }
        if let error = error {
            if (error as NSError).code == NSURLErrorCancelled {
                self?.cancellation?()
            } else {
                self?.failure?(error)
            }
        } else if let response = response as? HTTPURLResponse, let data = data {
            do {
                try self?.service.validate(statusCode: response.statusCode)
                let returnValue = try ReturnType(from: data)
                self?.success?(returnValue)
            } catch {
                self?.failure?(error)
            }
        } else {
            self?.failure?(APIRequestError.internalError(description: "Unable parse returned data."))
        }
    }

    // MARK: - Generators
    /// Creates the `APIRequest` to a URLRequest to be used in a URLSession.
    private var urlRequest: URLRequest {
        // add authorization into the HTTPParameters or HTTPBody as needed
        let urlData = authorization?.embedInto(request: self) ?? (self.params, self.body)

        // Create base URL String by combining the Service url and the endpoint url
        var urlString = service.baseURL + endpoint

        // Add Paramers to URL
        if let params = urlData.0 {
            urlString += "?" + params.map { return "\($0)=\($1)" }.joined(separator: "&")
        }

        // Setup URLRequest
        var request = URLRequest(url: URL(string: urlString)!)

        // Set URLRequest method
        request.httpMethod = method.rawValue

        // Add Body to URLRequest
        if let body = urlData.1 {
            do {
                let requestData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                request.httpBody = requestData
            } catch {
                #if DEBUG
                    print("☠️", "Failed to serialize HTTPBody", error.localizedDescription)
                #endif
            }
        }

        // Add headers to URLRequest
        if let headers = service.headers {
            for (field, value) in headers {
                request.addValue(value, forHTTPHeaderField: field)
            }
        }

        #if DEBUG
            print("🚀", method.rawValue, urlString)
        #endif

        return request
    }

    /// `URLSessionDataTask` backing the APIRequest, is reset whenever a property that effects `urlRequest` changes
    private var _task: URLSessionDataTask? {
        willSet {
            _task?.cancel()
        }
    }

    /// Accessor for `_task`, creates the `URLSessionDataTask` as needed
    private var task: URLSessionDataTask {
        set {
            fatalError("Cannot be set directly, please only use _task = nil")
        }
        get {
            if let task = _task {
                return task
            } else {
                let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: urlRequestCallback)
                _task = task
                return task
            }
        }
    }

    // MARK: - Init
    /**
        Creates a new APIRequest.

        - parameters:
            - endpoint:     The api endpoint relative to the baseURL of the APIService.
            - queryParams:  The url parameters for the HTTP Request.
            - body:         An optional json body for the HTTP Request.
            - method:       The method for the HTTP Request.

        - note: Only to be used by a class that conforms to APIService
     */
    public init(service: APIService.Type, endpoint: String, params: HTTPParameters? = nil, body: HTTPBody? = nil, method: APIRequest.HTTPMethod) {
        self.endpoint = endpoint
        self.body = body
        self.params = params
        self.method = method
        self.service = service
    }

    // MARK: - Setters
    /**
        Sets the callback on a successful `APIRequest`, called with the an object of the ReturnType.

        - parameters:
            - success: The block to be called on a successful request.

        - returns: self for method chaining as need
     */
    @discardableResult
    open func onSuccess(_ success: Success?) -> APIRequest {
        self.success = success
        return self
    }

    /**
        Sets the callback on a failed `APIRequest`, called with the error.

        - parameters:
            - failure: The block to be called on a failed request.

        - returns: self for method chaining as need
     */
    @discardableResult
    open func onFailure(_ failure: Failure?) -> APIRequest {
        self.failure = failure
        return self
    }

    /**
        Sets the callback on a cancelled `APIRequest`.

        - parameters:
            - cancellation: The block to be called on a cancelled request.

        - returns: self for method chaining as need
     */
    @discardableResult
    open func onCancellation(_ cancellation: Cancellation?) -> APIRequest {
        self.cancellation = cancellation
        return self
    }

    /**
        Sets the authorization for an `APIRequest`.

        - parameters:
            - authorization: The object used to authorize the request.

        - returns: self for method chaining as need
     */
    @discardableResult
    open func authorization(_ authorization: APIAuthorization?) -> APIRequest {
        self.authorization = authorization
        _task = nil
        return self
    }

    // MARK: - API
    /**
        Cancels the APIRequest, can be resumed using `perform()`

        - returns: self for method chaining as need
     */
    @discardableResult
    open func cancel() -> APIRequest {
        task.cancel()
        return self
    }

    /**
        Pauses the APIRequest, can be resumed using `perform()`. Has no effect if the APIRequest has compeleted or has been cancelled.

        - returns: self for method chaining as need
     */
    @discardableResult
    open func pause() -> APIRequest {
        task.suspend()
        return self
    }

    /**
        Performs the APIRequest. On a successful request the `success` closure will be called with the an object of the ReturnType. On a failed request the `failure` closure will be called with the error. On a cancelled request the `cancellation` closure will be called.

        - returns: self for method chaining as need
     */
    @discardableResult
    open func perform() -> APIRequest {
        task.resume()
        return self
    }

    /**
     */
    private var unmanaged: Unmanaged<APIRequest<ReturnType>>? {
        willSet {
            unmanaged?.release()
        }
    }
    open func autoManage() {
        unmanaged = Unmanaged.passRetained(self)
    }
}
