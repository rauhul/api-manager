//
//  APIRequestToken.swift
//  APIManager
//
//  Created by Rauhul Varma on 1/8/18.
//  Copyright © 2018 Rauhul Varma. All rights reserved.
//

open class APIRequestToken {

    // MARK: - Properties
    open var state: APIRequestState {
        return task.state == .completed ? .completed : .running
    }

    // MARK: - Private Properties

    /// `URLSessionDataTask` backing the APIRequest
    private var task: URLSessionDataTask
    private var retain: Unmanaged<APIRequestToken>?
    private var observation: NSKeyValueObservation?

    public init(_ dataTask: URLSessionDataTask) {
        task = dataTask
        task.resume()

        observation = task.observe(\.state) { [weak self] (task, change) in
            switch task.state {
            case .completed:
                self?.retain?.release()
                self?.observation?.invalidate()
            default:
                break
            }
        }
        retain = Unmanaged.passRetained(self)

        print("token init")
    }

    deinit {
        print("token deinit")
    }

    // MARK: - API
    /// Cancels the `APIRequest` represented by this token
    open func cancel() {
        task.cancel()
    }
}
