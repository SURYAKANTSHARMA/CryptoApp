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
    @Published var statistics: [StatisticModel] = []

    let coinDataService = CoinDataService()
    let markerDataService = MarketDataService()
    var anyCancellables = Set<AnyCancellable>()
    
    init() {        
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.global()) 
            .combineLatest(coinDataService.$allcoins)
            .map(filterAllCoinsUsing)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }.store(in: &anyCancellables)
        
        markerDataService
            .$marketData
            .map(mapGlobalMarketData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] statistics in
                self?.statistics = statistics
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
    
    private func mapGlobalMarketData(data: MarketDataModel?) -> [StatisticModel] {
            guard let data else {
                return []
            }
            
           return  [
            StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd),
            StatisticModel(title: "24h volume", value: data.volume),
            StatisticModel(title: "BTC Dominance", value: data.btcDominance),
            StatisticModel(title: "Porfolio value", value: "$0.0", percentageChange: 0)
            ]

    }
}
