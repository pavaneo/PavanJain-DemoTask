//
//  NetworkManagerTests.swift
//  Pavanjain-Task
//
//  Created by Pavan Kumar J on 03/12/24.
//

import XCTest
import Combine
@testable import PavanJain_DemoTask

final class NetworkManagerTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    
    func testFetchData_Success() {
        // Arrange
        let mockSession = MockURLSession()
        let mockData = """
        [{
            "name": "Bitcoin",
            "symbol": "BTC",
            "is_new": false,
            "is_active": true,
            "type": "coin"
          },
          {
            "name": "Ethereum",
            "symbol": "ETH",
            "is_new": false,
            "is_active": true,
            "type": "token"
          },
          {
            "name": "Ripple",
            "symbol": "XRP",
            "is_new": false,
            "is_active": false,
            "type": "coin"
          }]
        """.data(using: .utf8)!
        mockSession.data = mockData
        
        let networkManager = NetworkManager(session: mockSession)
        
        let expectation = XCTestExpectation(description: "Fetch data successfully")
        
        // Act
        networkManager.fetchData(from: "https://mock.url")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected successful completion")
                }
            }, receiveValue: { (coins: [CryptoCoin]) in
                // Assert
                XCTAssertEqual(coins.count, 3)
                XCTAssertEqual(coins[0].name, "Bitcoin")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNetworkManagerFetchData_Failure() {
        // Arrange
        let mockSession = MockURLSession()
        mockSession.error = URLError(.badServerResponse)
        let networkManager = NetworkManager(session: mockSession)
        let expectation = XCTestExpectation(description: "Fetch data failure")
        
        // Act
        networkManager.fetchData(from: "https://mock.url")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, NetworkError.noInternet)
                    expectation.fulfill()
                }
            }, receiveValue: { (_: [CryptoCoin]) in
                XCTFail("Expected failure, but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
