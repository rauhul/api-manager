//
//  APIService.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

import Foundation

/**
    `APIService` defines all the properties and methods a class must contain to be used as a service in an `APIRequest`.
    
    A class that conforms to APIService should also define all the endpoints relevent to that service.
 
    An endpoint might look like:
 
    ```
    open class func getUser(byId id: String) -> APIRequest<MyService> {
        return APIRequest<MyService>(endpoint: "/users", params: nil, body: ["id": id], method: .GET)
    }
    ```
 */
public protocol APIService {
    
    /**
        The base URL for this `APIService`.
     
        Endpoints in this service will be postpended to this URL segment. As a result a baseURL will generally look like the root URL of the API the service communicates with.
     
        A baseURL might look like: ```https://api.example.com``` with endpoints like: ```/users``` or ```/schedule```
     
        When interacting with more complicated APIs, it may be necessary to create subclasses of your service in order to maintain clean and readable code. In these cases the super-service should still have a baseURL as defined above. However the sub-services should have baseURLs of the form:
     
        ```
        override open class var baseURL: String {
            return super.baseURL + "/users"
        }
        ```
     */
    static var baseURL: String { get }
    
    /**
        The `HTTPHeaders` to be sent alongside the `APIRequest`s made by the endpoints in this `APIService`.
        
        An `APIRequest` does not send any `HTTPHeaders` by default, so any and all headers must be specified here.
     */
    static var headers: HTTPHeaders? { get }
}
