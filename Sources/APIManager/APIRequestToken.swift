//
//  APIRequestToken.swift
//  APIManager
//
//  Created by Rauhul Varma on 1/8/18.
//  Copyright © 2018 Rauhul Varma. All rights reserved.
//

import Foundation

/// A token representing an running or completed `APIRequest`. Allows running `APIRequest`s to be cancelled mid flight.
open class APIRequestToken {

    // MARK: - Properties
    /// Current state of the represented `APIRequest`.
    open var state: APIRequestState {
        return task.state == .completed ? .completed : .running
    }

    // MARK: - Private Properties
    /// `URLSessionDataTask` backing the APIRequest.
    private var task: URLSessionDataTask

    /// A reference to self, such that the APIRequest doesn't fall out of scope and get deallocaed before completing.
    private var retain: Unmanaged<APIRequestToken>?

    /// Observation of the `APIRequestToken.task` used to determine when then `APIRequest` has completed.
    private var observation: NSKeyValueObservation?

    // MARK: - Init
    /// Creates an `APIRequestToken` from a APIRequest task and starts it immediately.
    public init(_ dataTask: URLSessionDataTask) {
        task = dataTask
        observation = task.observe(\.state) { [weak self] (task, _) in
            switch task.state {
            case .completed:
                self?.retain?.release()
                self?.retain = nil
                self?.observation?.invalidate()
            default:
                break
            }
        }
        task.resume()
        retain = Unmanaged.passRetained(self)
    }

    // MARK: - API
    /// Cancels the `APIRequest` represented by this token
    open func cancel() {
        guard state != .completed else { return }
        task.cancel()
    }
}
