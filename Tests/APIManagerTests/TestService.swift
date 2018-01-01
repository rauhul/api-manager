//
//  TestService.swift
//  APIManager
//
//  Created by Rauhul Varma on 11/2/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

import Foundation
import APIManager

class TestService: APIService {
    
    static var baseURL: String = "https://httpbin.org"

    static var headers: HTTPHeaders?

    open class func get() -> APIRequest<TestService, JSON> {
        return APIRequest<TestService, JSON>(endpoint: "/get", method: .GET)
    }

    open class func post() -> APIRequest<TestService, JSON> {
        return APIRequest<TestService, JSON>(endpoint: "/post", method: .POST)
    }

    open class func head() -> APIRequest<TestService, Data> {
        return APIRequest<TestService, Data>(endpoint: "/get", method: .HEAD)
    }

    open class func put() -> APIRequest<TestService, JSON> {
        return APIRequest<TestService, JSON>(endpoint: "/put", method: .PUT)
    }

    open class func delete() -> APIRequest<TestService, JSON> {
        return APIRequest<TestService, JSON>(endpoint: "/delete", method: .DELETE)
    }

    open class func options() -> APIRequest<TestService, Data> {
        return APIRequest<TestService, Data>(endpoint: "/get", method: .OPTIONS)
    }

    open class func patch() -> APIRequest<TestService, JSON> {
        return APIRequest<TestService, JSON>(endpoint: "/patch", method: .PATCH)
    }

}
