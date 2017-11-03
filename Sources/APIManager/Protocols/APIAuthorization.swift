//
//  APIAuthorization.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

import Foundation

/// `APIAuthorization` defines all the properties and methods a class must contain to be used as an authorization for an `APIRequest`.
public protocol APIAuthorization {
    
    // TODO: Document
    func embedInto<Service, ReturnType>(request: APIRequest<Service, ReturnType>) -> (HTTPParameters?, HTTPBody?)
}
