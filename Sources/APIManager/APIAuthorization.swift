//
//  APIAuthorization.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2020 Rauhul Varma. All rights reserved.
//

/// `APIAuthorization` defines all the properties and methods a class must
/// contain to be used as an authorization for an `APIRequest`.
public protocol APIAuthorization {

    /// Configuration point for an `APIAuthorization` to inject additional
    /// parameters into a request.
    func parametersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPParameters?
    /// Configuration point for an `APIAuthorization` to inject additional body
    /// components into a request.
    func bodyFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPBody?
    /// Configuration point for an `APIAuthorization` to inject additional
    /// headers into a request.
    func headersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPHeaders?
}

public extension APIAuthorization {
    /// Placeholder implementation, returns nil.
    func parametersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPParameters? { nil }
    /// Placeholder implementation, returns nil.
    func bodyFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPBody? { nil }
    /// Placeholder implementation, returns nil.
    func headersFor<ReturnType>(request: APIRequest<ReturnType>) -> HTTPHeaders? { nil }
}
