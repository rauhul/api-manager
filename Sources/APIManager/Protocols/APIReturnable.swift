//
//  APIReturnable.swift
//  APIManager
//
//  Created by Rauhul Varma on 10/29/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

import Foundation

// TODO: Document
public protocol APIReturnable {
    // TODO: Document
    init(from: Data) throws
}

// TODO: Document
public extension APIReturnable where Self: Decodable {

    // TODO: Document
    public init(from data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}
