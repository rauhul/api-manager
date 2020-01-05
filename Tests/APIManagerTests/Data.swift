//
//  Data.swift
//  APIManagerTests
//
//  Created by Rauhul Varma on 11/2/17.
//  Copyright © 2020 Rauhul Varma. All rights reserved.
//

import Foundation
import APIManager

extension Data: APIReturnable {
    public init(from: Data) throws {
        self = from
    }
}
