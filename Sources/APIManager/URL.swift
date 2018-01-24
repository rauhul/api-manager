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
