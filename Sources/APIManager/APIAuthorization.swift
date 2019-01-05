//
//  APIAuthorization.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

/// `APIAuthorization` defines all the properties and methods a class must contain to be used as an authorization for an `APIRequest`.
public protocol APIAuthorization {

    /// Defines how to embed a custom `APIAuthorization` object into an `APIRequest`. This can be done by modifying the request's one or more of the following: url parameters, body, headers
    func parametersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPParameters?
    func bodyFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPBody?
    func headersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPHeaders?
}

public extension APIAuthorization {
    public func parametersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPParameters? { return nil }
    public func bodyFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPBody? { return nil }
    public func headersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPHeaders? { return nil }
}
