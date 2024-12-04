//
//  Untitled.swift
//  Pavanjain-Task
//
//  Created by Pavan Kumar J on 03/12/24.
//

import XCTest
import Combine
@testable import PavanJain_DemoTask

class CoinViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    func testFetchCoins_Success() {
        
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
          },
          {
            "name": "Cardano",
            "symbol": "ADA",
            "is_new": true,
            "is_active": true,
            "type": "coin"
          }]
        """.data(using: .utf8)!
        
        // Arrange
        let mockSession = MockURLSession()
        mockSession.data = mockData
        let networkManager = NetworkManager(session: mockSession)
        let viewModel = CoinViewModel(networkManager: networkManager)

        // Act
        let expectation = XCTestExpectation(description: "Fetch coins successfully")
        viewModel.fetchCoins()

        viewModel.$coins
            .dropFirst() // Ignore initial empty state
            .sink(receiveValue: { coins in
                // Assert
                XCTAssertEqual(coins.count, 4)
                XCTAssertEqual(coins[0].name, "Bitcoin")
                XCTAssertEqual(coins[1].name, "Ethereum")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSearch() {
        // Arrange
        let viewModel = CoinViewModel()
        viewModel.coins = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "coin", isActive: true, isNew: true)
        ]
        
        // Act
        viewModel.search(query: "bit")
        
        // Assert
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins[0].name, "Bitcoin")
    }
    
    func testSearchResults_when_empty() {
        // Arrange
        let viewModel = CoinViewModel()
        
        // Act
        viewModel.search(query: "")
        
        // Assert
        XCTAssertEqual(viewModel.filteredCoins.count, 0)
    }
    
    func test_filter_based_on_active_coins() {
        // Arrange
        let viewModel = CoinViewModel()
        
        viewModel.coins = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "token", isActive: true, isNew: false),
            CryptoCoin(name: "Ripple", symbol: "XRP", type: "token", isActive: false, isNew: false),
            CryptoCoin(name: "Cardano", symbol: "ADA", type: "coin", isActive: true, isNew: true)
        ]
        
        // Act
        viewModel.apply(conditions: ["Active Coins"])
        
        // Assert
        XCTAssertEqual(viewModel.filteredCoins.count, 3)
    }
    
    func test_filter_based_on_inActive_coins() {
        // Arrange
        let viewModel = CoinViewModel()
        
        viewModel.coins = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "token", isActive: true, isNew: false),
            CryptoCoin(name: "Ripple", symbol: "XRP", type: "token", isActive: false, isNew: false),
            CryptoCoin(name: "Cardano", symbol: "ADA", type: "coin", isActive: true, isNew: true)
        ]
        
        // Act
        viewModel.apply(conditions: ["Inactive Coins"])
        
        // Assert
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
    }
    
    func test_filter_based_on_only_tokens() {
        // Arrange
        let viewModel = CoinViewModel()
        
        viewModel.coins = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "token", isActive: true, isNew: false),
            CryptoCoin(name: "Ripple", symbol: "XRP", type: "token", isActive: false, isNew: false),
            CryptoCoin(name: "Cardano", symbol: "ADA", type: "coin", isActive: true, isNew: true)
        ]
        
        // Act
        viewModel.apply(conditions: ["Only Tokens"])
        
        // Assert
        XCTAssertEqual(viewModel.filteredCoins.count, 2)
    }
    
    func test_filter_based_on_only_coins() {
        // Arrange
        let viewModel = CoinViewModel()
        
        viewModel.coins = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "token", isActive: true, isNew: false),
            CryptoCoin(name: "Ripple", symbol: "XRP", type: "token", isActive: false, isNew: false),
            CryptoCoin(name: "Cardano", symbol: "ADA", type: "coin", isActive: true, isNew: true)
        ]
        
        // Act
        viewModel.apply(conditions: ["Only Coins"])
        
        // Assert
        XCTAssertEqual(viewModel.filteredCoins.count, 2)
    }
    
    func test_filter_based_on_new_coins() {
        // Arrange
        let viewModel = CoinViewModel()
        
        viewModel.coins = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "token", isActive: true, isNew: false),
            CryptoCoin(name: "Ripple", symbol: "XRP", type: "token", isActive: false, isNew: false),
            CryptoCoin(name: "Cardano", symbol: "ADA", type: "coin", isActive: true, isNew: true)
        ]
        
        // Act
        viewModel.apply(conditions: ["New Coins"])
        
        // Assert
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
    }
    
    func test_filter_based_on_unknown_key() {
        // Arrange
        let viewModel = CoinViewModel()
        
        viewModel.coins = [
            CryptoCoin(name: "Bitcoin", symbol: "BTC", type: "coin", isActive: true, isNew: false),
            CryptoCoin(name: "Ethereum", symbol: "ETH", type: "token", isActive: true, isNew: false),
            CryptoCoin(name: "Ripple", symbol: "XRP", type: "token", isActive: false, isNew: false),
            CryptoCoin(name: "Cardano", symbol: "ADA", type: "coin", isActive: true, isNew: true)
        ]
        
        // Act
        viewModel.apply(conditions: ["New Coins1"])
        
        // Assert
        XCTAssertEqual(viewModel.filteredCoins.count, 4)
    }
}

