//
//  HTTPParameters.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/21/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

/// `HTTPParameters` are set of querys used to access specific data via an `APIRequest`. These parameters will be postpended to a url in form `?key1=value1&key2=value...` etc.
public typealias HTTPParameters = [String: String]
