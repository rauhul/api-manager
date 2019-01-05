//
//  URL.swift
//  APIManager
//
//  Created by Rauhul Varma on 1/7/18.
//  Copyright © 2018 Rauhul Varma. All rights reserved.
//

import Foundation

/// Extension of Foundation.URL.
extension URL {

    /// Initializer for creating a URL with a base string and optional URLParameters.
    init?(base: String, paramaters: HTTPParameters) {
        var urlString = base

        if !paramaters.isEmpty {
            urlString += "?" + paramaters.map { return "\($0)=\($1)" }.joined(separator: "&")
        }

        self.init(string: urlString)
    }

}

/// Extension of Foundation.URLRequest.
extension URLRequest {

    /// Initializer for creating a URLRequest with an HTTPMethod, HTTPBody, and HTTPHeaders.
    init(url: URL, method: HTTPMethod, body: HTTPBody, headers: HTTPHeaders) {
        self.init(url: url)
        httpMethod = method.rawValue

        if !body.isEmpty {
            do {
                let requestData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                httpBody = requestData
            } catch {
                #if DEBUG
                print("☠️", "Failed to serialize HTTPBody", error.localizedDescription)
                #endif
            }
        }

        if !headers.isEmpty {
            for (field, value) in headers {
                addValue(value, forHTTPHeaderField: field)
            }
        }
    }

}
