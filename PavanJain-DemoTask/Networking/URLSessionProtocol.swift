//
//  URLSessionProtocol.swift
//  PavanJain-DemoTask
//
//  Created by Pavan Kumar J on 03/12/24.
//

import Combine
import Foundation

// Define URLSessionProtocol
public protocol URLSessionProtocol {
    func customDataTaskPublisher(for url: URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError>
}

// Extend URLSession to conform to URLSessionProtocol
extension URLSession: URLSessionProtocol {
    public func customDataTaskPublisher(for url: URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> {
        self.dataTaskPublisher(for: url)
            .mapError { $0 as URLError }
            .eraseToAnyPublisher()
    }
}
