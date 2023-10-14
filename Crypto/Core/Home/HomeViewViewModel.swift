//
//  HomeViewViewModel.swift
//  Crypto
//
//  Created by Surya on 13/09/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText = ""
    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "title", value: "value", percentageChange: 1),
        StatisticModel(title: "title", value: "value"),
        StatisticModel(title: "title", value: "value"),
        StatisticModel(title: "title", value: "value", percentageChange: -7)
    ]

    let service = CoinDataService()
    var anyCancellables = Set<AnyCancellable>()
    
    init() {        
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.global()) 
            .combineLatest(service.$allcoins)
            .map(filterAllCoinsUsing)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }.store(in: &anyCancellables)
         
    }
    
    private func filterAllCoinsUsing(_ text: String, _ allCoins: [CoinModel]) -> [CoinModel] {
        if text.isEmpty {
            return allCoins
        }
        return allCoins
            .filter {
                $0.name.lowercased().contains(text.lowercased())
                || $0.symbol.lowercased().contains(text.lowercased())
                || $0.id.lowercased().contains(text.lowercased())
            }
        
    }
}
