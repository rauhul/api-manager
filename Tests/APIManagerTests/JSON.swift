//
//  JSON.swift
//  APIManagerTests
//
//  Created by Rauhul Varma on 11/2/17.
//  Copyright © 2020 Rauhul Varma. All rights reserved.
//

import Foundation
import APIManager

class JSON: APIReturnable {
    let rawDictionary: [String: Any]

    required init(from: Data) throws {
        let json = try JSONSerialization.jsonObject(with: from, options: [])
        if let json = json as? [String: Any] {
            rawDictionary = json
        } else {
            throw NSError(domain: "Conversion Error. Failed to convert data to json dictionary.", code: 1, userInfo: nil)
        }
    }
}
