//
//  APIRequestError.swift
//  APIManager
//
//  Created by Rauhul Varma on 1/8/18.
//  Copyright © 2018 Rauhul Varma. All rights reserved.
//

/// Enumeration of the Errors that can occur during an APIRequest.
public enum APIRequestError: Error {
    /// occurs when an APIRequest gets a response with an invalid response code, additionally provides a decription of the error code
    case invalidHTTPReponse(code: Int, description: String)

    /// occurs when an APIRequest encounters an inconsistancy it does not know how to handle, additionally provides a decription of the error
    case internalError(description: String)
}
