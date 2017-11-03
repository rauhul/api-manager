//
//  APIRequest.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

import Foundation

/**
    Base class for creating APIRequests.

    - note: `APIRequests` should be created through a class that conforms to `APIService`.
 */
open class APIRequest<Service: APIService, ReturnType: APIReturnable> {

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
    public typealias Failure = (_ reason: String) -> Void

    // MARK: - Required Properties
    /// The endpoint for the HTTP Request relative to the baseURL of the Service.
    open var endpoint: String

    /// The method for the HTTP Request.
    open var method: HTTPMethod

    // MARK: - Optional Properties
    /// The url parameters for the HTTP Request.
    open var params: HTTPParameters?

    /// The json body for the HTTP Request.
    open var body: HTTPBody?

    // MARK: - Callbacks
    /// The callback on a successful `APIRequest`, called with the json response.
    open private(set) var success: Success?

    /// The callback on a failed `APIRequest`, called with the error description.
    open private(set) var failure: Failure?

    // MARK: - Performing a request
    /**
        Converts the `APIRequest` to a URLRequest to be used in a URLSession.

        - parameters:
            - authorization: An optional `APIAuthorization` to perform the request with. This authorization will be embeded into the URLRequest as defined by the authorization.

        - returns: A URL Request representing the APIRequest.
     */
    open func urlRequest(withAuthorization authorization: APIAuthorization?) -> URLRequest {

        // add authorization into the HTTPParameters or HTTPBody as needed
        let urlData = authorization?.embedInto(request: self) ?? (self.params, self.body)

        // Create base URL String by combining the Service url and the endpoint url
        var urlString = Service.baseURL + endpoint

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
        if let headers = Service.headers {
            for (field, value) in headers {
                request.addValue(value, forHTTPHeaderField: field)
            }
        }

        #if DEBUG
            print("🚀", method.rawValue, urlString)
        #endif

        return request
    }

    /**
        Performs the APIRequest

        - parameters:
            - authorization: An optional Authorization to perform the request with.
        - note:
            On a successful request the `success` closure will be called with the response json.
            On a failed request the `failure` closure will be called with the error description.
     */
    open func perform(withAuthorization authorization: APIAuthorization?) {
        let request = urlRequest(withAuthorization: authorization)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.failure?(error.localizedDescription)
                return
            }

            if let response = response as? HTTPURLResponse, let data = data {
                // TODO: Abstract away
                if !(200..<300).contains(response.statusCode) {
                    self.failure?(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))
                    return
                }

                do {
                    let returnValue = try ReturnType.init(from: data)
                    self.success?(returnValue)
                    return
                } catch {
                    self.failure?(error.localizedDescription)
                    return
                }
            }

            self.failure?("Internal error; unable parse returned data.")
            return
        }
        task.resume()
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
    public init(endpoint: String, params: HTTPParameters? = nil, body: HTTPBody? = nil, method: APIRequest.HTTPMethod) {
        self.endpoint = endpoint
        self.body = body
        self.params = params
        self.method = method
    }

    // MARK: - Callback Setters
    /**
        Sets the callback on a successful `APIRequest`, called with the json response.

        - parameters:
            - success: The block to be called on a successful request.
     */
    @discardableResult
    open func onSuccess(_ success: Success?) -> APIRequest {
        self.success = success
        return self
    }

    /**
        Sets the callback on a failed `APIRequest`, called with the json response.

        - parameters:
            - failure: The block to be called on a failed request.
     */
    @discardableResult
    open func onFailure(_ failure: Failure?) -> APIRequest {
        self.failure = failure
        return self
    }
}
