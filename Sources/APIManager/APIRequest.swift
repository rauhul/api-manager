//
//  APIRequest.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

import Foundation

/// Base class for creating APIRequests.
/// - note: `APIRequests` should be created through a class that conforms to `APIService`.
open class APIRequest<ReturnType: APIReturnable> {

    // MARK: - Types & Aliases
    public enum APIRequestResult {
        case success(ReturnType)
        case cancellation
        case failure(Error)
    }

    /// Alias for the callback when an `APIRequest` completes.
    public typealias Completion = (APIRequestResult) -> Void

    // MARK: - Required Properties
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

    // MARK: - Generics
    /// The `APIService` the `APIRequest` is part of.
    open private(set) var service: APIService.Type

    // MARK: - Optional Properties
    /// The object used to authorize the request.
    open private(set) var authorization: APIAuthorization?

    // MARK: - Callbacks
    /// The callback on a completed `APIRequest`, called with the result.
    open private(set) var completion: Completion?

    /// The callback for the `URLRequest` used to make the `APIRequest`.
    private func urlRequestCallback(data: Data?, response: URLResponse?, error: Error?) {
        if let error = error {
            if (error as NSError).code == NSURLErrorCancelled {
                completion?(.cancellation)
            } else {
                completion?(.failure(error))
            }
        } else if let response = response as? HTTPURLResponse, let data = data {
            do {
                try service.validate(statusCode: response.statusCode)
                let returnValue = try ReturnType(from: data)
                completion?(.success(returnValue))
            } catch {
                completion?(.failure(error))
            }
        } else {
            completion?(.failure(APIRequestError.internalError(description: "Unable parse returned data.")))
        }
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
        print("🚀", method.rawValue, url.absoluteString)

        #if DEBUG
            print("🚀", method.rawValue, url.absoluteString)
        #endif
        return URLRequest(url: url, method: method, body: combinedBody, headers: combinedHeaders)
    }

    /// Creates a `URLSessionDataTask` representing the `APIRequest`.
    private var dataTask: URLSessionDataTask {
        return URLSession.shared.dataTask(with: urlRequest, completionHandler: urlRequestCallback)
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

    // MARK: - Setters

    /// Sets the callback on a completed `APIRequest`, called with the result.
    /// - parameters:
    ///     - comepletion: The block to be called on a completed request.
    /// - returns: `self` for method chaining as needed.
    @discardableResult
    open func onCompletion(_ completion: Completion?) -> APIRequest {
        self.completion = completion
        return self
    }

    /// Sets the authorization for an `APIRequest`.
    /// - parameters:
    ///     - authorization: The object used to authorize the request.
    /// - returns: `self` for method chaining as needed.
    @discardableResult
    open func authorization(_ authorization: APIAuthorization?) -> APIRequest {
        self.authorization = authorization
        return self
    }

    /// Performs the APIRequest. On a successful request the `success` closure will be called with the an object of the ReturnType. On a failed request the `failure` closure will be called with the error. On a cancelled request the `cancellation` closure will be called.
    /// - returns: an `APIRequestToken` so the request can be cancelled later and state can be observed.
    @discardableResult
    open func perform() -> APIRequestToken {
        return APIRequestToken(dataTask)
    }
}
