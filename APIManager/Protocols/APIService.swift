//
//  APIService.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2017 rauhul. All rights reserved.
//

import Foundation

// apiservices defines all the api endpoints for a particular service
/// `APIService` defines all the properties and methods a class must contain to be used as a service in an `APIRequest`
public protocol APIService {
    
    /// The base URL for this Service. Endpoints in this service will be postpended to this URL segment
    static var baseURL: String { get }
    
    // ADD Authorization to request
    
    // Request Headers
    
    
}
