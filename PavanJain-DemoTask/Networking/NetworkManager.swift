//
//  NetworkManager.swift
//  Pavanjain-Task
//
//  Created by Pavan Kumar J on 02/12/24.
//

import Foundation
import Combine

/// Network Error - ENUM
enum NetworkError: Error {
    case noInternet
    case badURL
    case requestFailed
    case decodingError
    case unknown
    
    var description: String {
        switch self {
        case .noInternet:
            return "No internet connection"
        case .badURL:
            return "Bad URL"
        case .decodingError:
            return "Decoding Error"
            case .requestFailed:
            return "Request Failed"
        case .unknown:
            return "Unknown Error"
        }
    }
}

// Class - Network class
class NetworkManager {
    static let shared = NetworkManager()

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchData<T: Decodable>(from url: String) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: url) else {
            return Fail(error: .badURL)
                .eraseToAnyPublisher()
        }

        return session.customDataTaskPublisher(for: url)
            .mapError { error -> NetworkError in
                return .noInternet
            }
            .flatMap { data, _ in
                Just(data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { _ in
                        return NetworkError.decodingError
                    }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

