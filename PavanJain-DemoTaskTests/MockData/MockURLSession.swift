//
//  MockURLSession.swift
//  Pavanjain-Task
//
//  Created by Pavan Kumar J on 03/12/24.
//

import Combine
import Foundation
import PavanJain_DemoTask

// Mock URLSession for dependency injection
class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: URLError?
    
    func customDataTaskPublisher(for url: URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLError> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        let response = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        return Just((data: data ?? Data(), response: response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}
