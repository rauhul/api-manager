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

    open class func get() -> APIRequest<JSON> {
        return APIRequest<JSON>(service: self, endpoint: "/get", method: .GET)
    }

    open class func post() -> APIRequest<JSON> {
        return APIRequest<JSON>(service: self, endpoint: "/post", method: .POST)
    }

    open class func head() -> APIRequest<Data> {
        return APIRequest<Data>(service: self, endpoint: "/get", method: .HEAD)
    }

    open class func put() -> APIRequest<JSON> {
        return APIRequest<JSON>(service: self, endpoint: "/put", method: .PUT)
    }

    open class func delete() -> APIRequest<JSON> {
        return APIRequest<JSON>(service: self, endpoint: "/delete", method: .DELETE)
    }

    open class func options() -> APIRequest<Data> {
        return APIRequest<Data>(service: self, endpoint: "/get", method: .OPTIONS)
    }

    open class func patch() -> APIRequest<JSON> {
        return APIRequest<JSON>(service: self, endpoint: "/patch", method: .PATCH)
    }

}
