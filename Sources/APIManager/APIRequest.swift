//
//  APIRequest.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/14/18.
//  Copyright © 2018 Rauhul Varma. All rights reserved.
//

import Foundation

@objc private enum APIRequestState: Int {
    case ready
    case executing
    case finished
}

open class APIRequestCenter {
    static let `default` = APIRequestCenter()
    private init() { }

    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 10
        return queue
    }()
}

/// Base class for creating APIRequests.
/// - note: `APIRequests` should be created through a class that conforms to `APIService`.
open class APIRequest<ReturnType: APIReturnable>: Operation {

    // MARK: - Types & Aliases
    public enum APIRequestResult {
        case success(ReturnType, HTTPCookies)
        case cancellation
        case failure(Error)
    }

    /// Alias for the callback when an `APIRequest` completes.
    public typealias Completion = (APIRequestResult) -> Void

    // MARK: - Operation Properties
    /// DispatchQueue used to serialize access to `state`.
    private let stateQueue = DispatchQueue(label: "com.rauhul.APIManager.stateQueue", attributes: .concurrent)

    /// private variable backing `state`.
    private var _state: APIRequestState = .ready

    /// objc visible setter and getter for `_state`.
    @objc private dynamic var state: APIRequestState {
        get {
            return stateQueue.sync { _state }
        }
        set {
            stateQueue.sync(flags: .barrier) { _state = newValue }
        }
    }

    open         override var isReady:        Bool { return state == .ready && super.isReady }
    public final override var isExecuting:    Bool { return state == .executing }
    public final override var isFinished:     Bool { return state == .finished }
    public final override var isAsynchronous: Bool { return true }

    private var dataTask: URLSessionDataTask?

    // MARK: - API Properties
    /// The endpoint for the HTTP Request relative to the baseURL of the `service`.
    open private(set) var endpoint: String

    /// The `HTTPMethod` for the HTTP Request.
    open private(set) var method: HTTPMethod

    /// The url parameters for the HTTP Request.
    open private(set) var parameters: HTTPParameters

    /// The json body for the HTTP Request.
    open private(set) var body: HTTPBody

    /// The headers for the HTTP Request.
    open private(set) var headers: HTTPParameters

    /// The `APIService` the `APIRequest` is part of.
    open private(set) var service: APIService.Type

    /// The object used to authorize the request.
    open private(set) var authorization: APIAuthorization?

    /// Sets the authorization for an `APIRequest`.
    /// - parameters:
    ///     - authorization: The object used to authorize the request.
    /// - returns: `self` for method chaining as needed.
    @discardableResult
    open func authorization(_ authorization: APIAuthorization?) -> APIRequest {
        self.authorization = authorization
        return self
    }

    /// The callback on a completed `APIRequest`, called with the result.
    open private(set) var completion: Completion?

    /// Sets the callback on a completed `APIRequest`, called with the result.
    /// - parameters:
    ///     - comepletion: The block to be called on a completed request.
    /// - returns: `self` for method chaining as needed.
    @discardableResult
    open func onCompletion(_ completion: Completion?) -> APIRequest {
        self.completion = completion
        return self
    }

    // MARK: - Generators
    /// Creates a `URLRequest` representing the `APIRequest`.
    private var urlRequest: URLRequest {

        func combine<K, V>(dictionarys: Dictionary<K, V>...) -> Dictionary<K, V> {
            var combinedDictionary = Dictionary<K, V>()
            for dictionary in dictionarys {
                for (key, value) in dictionary {
                    combinedDictionary[key] = value
                }
            }
            return combinedDictionary
        }

        let serviceParamaters = service.paramaters
        let serviceBody = service.body
        let serviceHeaders = service.headers

        let requestParameters = parameters
        let requestBody = body
        let requestHeaders = headers

        let authParamaters = authorization?.parametersFor(request: self) ?? [:]
        let authBody = authorization?.bodyFor(request: self) ?? [:]
        let authHeaders = authorization?.headersFor(request: self) ?? [:]

        let combinedParameters = combine(dictionarys: serviceParamaters, requestParameters, authParamaters)
        let combinedBody = combine(dictionarys: serviceBody, requestBody, authBody)
        let combinedHeaders = combine(dictionarys: serviceHeaders, requestHeaders, authHeaders)

        let url = URL(base: service.baseURL + endpoint, paramaters: combinedParameters)!

        #if DEBUG
            print("🚀", method.rawValue, url.absoluteString)
        #endif

        return URLRequest(url: url, method: method, body: combinedBody, headers: combinedHeaders)
    }

    // MARK: - Init
    /// Creates a new APIRequest.
    /// - parameters:
    ///     - endpoint:     The api endpoint relative to the baseURL of the APIService.
    ///     - queryParams:  The url parameters for the HTTP Request.
    ///     - body:         An optional json body for the HTTP Request.
    ///     - method:       The method for the HTTP Request.
    /// - note: Only to be used by a class that conforms to APIService.
    public init(service: APIService.Type, endpoint: String, parameters: HTTPParameters = [:], body: HTTPBody = [:], headers: HTTPHeaders = [:], method: HTTPMethod) {
        self.service = service
        self.endpoint = endpoint
        self.body = body
        self.parameters = parameters
        self.headers = headers
        self.method = method
    }

    // MARK: - Operation
    // MARK: Keypaths for KVC
    @objc private dynamic class func keyPathsForValuesAffectingIsReady() -> Set<String> {
        return [#keyPath(state)]
    }

    @objc private dynamic class func keyPathsForValuesAffectingIsExecuting() -> Set<String> {
        return [#keyPath(state)]
    }

    @objc private dynamic class func keyPathsForValuesAffectingIsFinished() -> Set<String> {
        return [#keyPath(state)]
    }

    // MARK: API
    public final override func start() {
        if isCancelled {
            completion?(.cancellation)
            return
        }

        state = .executing

        dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: urlRequestCallback)
        dataTask?.resume()
    }

    /// The callback for the `URLRequest` used to make the `APIRequest`.
    private func urlRequestCallback(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            if (error as NSError).code == NSURLErrorCancelled {
                completion?(.cancellation)
                state = .finished
            } else {
                completion?(.failure(error))
                state = .finished
            }
        } else if let response = response as? HTTPURLResponse, let data = data {
            do {
                try service.validate(statusCode: response.statusCode)
                let returnValue = try ReturnType(from: data)
                completion?(.success(returnValue, response.allHeaderFields))
                state = .finished
            } catch {
                completion?(.failure(error))
                state = .finished
            }
        } else {
            completion?(.failure(APIRequestError.internalError(description: "Unable parse returned data.")))
            state = .finished
        }
    }

    open override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }

    open func launch(on queue: OperationQueue? = nil) {
        if let queue = queue {
            queue.addOperation(self)
        } else {
            APIRequestCenter.default.queue.addOperation(self)
        }
    }
}
