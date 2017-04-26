//
//  JSONValidationResult.swift
//  APIManager
//
//  Created by Rauhul Varma on 4/24/17.
//  Copyright © 2017 Rauhul Varma. All rights reserved.
//

// TODO: Document
public enum JSONValidationResult {
    // should success also have a JSON assocaited type so that data can be extrated by the service before being returned to the success callback
    // this could be useful when all endpoints return errors/data in the same form
    // TODO: Document
    case success
    
    // is it worth replacing error with 'reason' or 'cause'
    // TODO: Document
    case failure(error: String)
}
