//
//  CoinViewModel.swift
//  Pavanjain-Task
//
//  Created by Pavan Kumar J on 02/12/24.
//

import Foundation
import Combine

/// Class - CoinViewModel Conforms to ObservableObject
class CoinViewModel: ObservableObject {
    @Published var coins: [CryptoCoin] = []
    @Published var filteredCoins: [CryptoCoin] = []
    @Published var error: NetworkError?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManager
    private let apiURL = "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/"
    
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    // Fetch coins
    func fetchCoins() {
        self.networkManager.fetchData(from: apiURL)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.error = error
                    print("Error fetching coins: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] (coins: [CryptoCoin]) in
                self?.coins = coins
                self?.filteredCoins = coins
                self?.error = nil
            })
            .store(in: &cancellables)
    }
    
    func apply(conditions: [String]) {
        // Start with all coins
        filteredCoins = coins
        
        for condition in conditions {
            switch condition {
            case "Active Coins":
                filteredCoins = filteredCoins.filter { $0.isActive }
            case "Inactive Coins":
                filteredCoins = filteredCoins.filter { !$0.isActive }
            case "Only Tokens":
                filteredCoins = filteredCoins.filter { $0.type == "token" }
            case "Only Coins":
                filteredCoins = filteredCoins.filter { $0.type == "coin" }
            case "New Coins":
                filteredCoins = filteredCoins.filter { $0.isNew && $0.isNew }
            default:
                print("Unknown filter condition: \(condition)")
            }
        }
    }
    
    // Search logic
    func search(query: String) {
        guard !query.isEmpty else {
            filteredCoins = coins
            return
        }
        filteredCoins = coins.filter { coin in
            coin.name.lowercased().contains(query.lowercased()) ||
            coin.symbol.lowercased().contains(query.lowercased())
        }
    }
}


