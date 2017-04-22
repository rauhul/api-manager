//
//  APIService.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2017 rauhul. All rights reserved.
//

import Foundation

// TODO: Document
// apiservices defines all the api endpoints for a particular service
/// `APIService` defines all the properties and methods a class must contain to be used as a service in an `APIRequest`
public protocol APIService {
    
    /// The base URL for this Service. Endpoints in this service will be postpended to this URL segment
    static var baseURL: String { get }
    
    /// Request HTTP Headers
    static var headers: HTTPHeaders? { get }
    
    // TODO: Document
    static func validate(json: JSON) -> JSONValidationResult
}

// TODO: Document
public enum JSONValidationResult {
    // should success also have a JSON assocaited type so that data can be extrated by the service before being returned to the success callback
    // this could be useful when all endpoints return errors/data in the same form
    // TODO: Document
    case success
    
    // is it worth replacing error with 'reason' or 'cause'
    // TODO: Document
    case failure(error: String)
}
