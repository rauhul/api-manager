//
//  URLRequest.swift
//  APIManager
//
//  Created by Rauhul Varma on 1/7/18.
//  Copyright © 2018 Rauhul Varma. All rights reserved.
//

import Foundation

extension URLRequest {

    init(url: URL, method: HTTPMethod, body: HTTPBody?, headers: HTTPHeaders?) {
        self.init(url: url)
        httpMethod = method.rawValue

        if let body = body {
            do {
                let requestData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                httpBody = requestData
            } catch {
                #if DEBUG
                    print("☠️", "Failed to serialize HTTPBody", error.localizedDescription)
                #endif
            }
        }

        if let headers = headers {
            for (field, value) in headers {
                addValue(value, forHTTPHeaderField: field)
            }
        }
    }

}
