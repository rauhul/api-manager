//
//  APIRequestState.swift
//  APIManager
//
//  Created by Rauhul Varma on 1/8/18.
//  Copyright © 2018 Rauhul Varma. All rights reserved.
//

/// Describes the current state of an `APIRequest`
public enum APIRequestState {
    /// The APIRequest is in progress
    case running

    // The APIRequest has called one its call backs and exited
    case completed
}
