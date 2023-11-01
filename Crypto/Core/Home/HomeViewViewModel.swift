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
    @Published var selectedCoin:  CoinModel? = nil
    @Published var sortOption: SortOption = .holding
    
    let coinDataService = CoinDataService()
    let markerDataService = MarketDataService()
    let portfolioServiceContainer = PortfolioServiceContainer()
    
    var anyCancellables = Set<AnyCancellable>()
    
    init() {
        let searchSharedPublisher = $searchText.share()

        searchSharedPublisher
            .debounce(for: 0.3, scheduler: DispatchQueue.global()) 
            .combineLatest(coinDataService.$allcoins, $sortOption)
            .map(filterAndSortCoins)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }.store(in: &anyCancellables)
        
        searchSharedPublisher
            .filter { $0.isEmpty }
            .sink { [weak self] _ in
                self?.selectedCoin = nil
            }.store(in: &anyCancellables)
        
        markerDataService
            .$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] statistics in
                self?.statistics = statistics
            }.store(in: &anyCancellables)
        
        $allCoins
            .combineLatest(portfolioServiceContainer
                .$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] porfolioCoins in
                guard let self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: porfolioCoins)
            }.store(in: &anyCancellables)
   
    }
    
    public func updatePortfolio(coin: CoinModel,
                                amount: Double) {
        portfolioServiceContainer.updatePortfolio(coin: coin, amount: amount)
    }
    
    
    private func filterAndSortCoins(text: String,
                                    coins: [CoinModel],
                                    sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
                    coin.symbol.lowercased().contains(lowercasedText) ||
                    coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holding:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }

    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holding:
            return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingReversed:
            return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        default:
            return coins
        }
    }
    
    
    private func convertToCoinModel(_ text: String, _ allCoins: [CoinModel]) -> [CoinModel] {
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
    
    private func mapGlobalMarketData(data: MarketDataModel?,
                                     portfolioCoins: [CoinModel]) -> [StatisticModel] {
            guard let data else {
                return []
            }
        
          let portfolioValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0, +)
            
          let previousPortfolioValue = portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentageChange = (coin.priceChangePercentage24H ?? 0)/100
                
                let previousCoinValue = currentValue / (1 + percentageChange)
                return previousCoinValue
            }
            .reduce(0, +)
        
        
          let percentageChange = ((portfolioValue - previousPortfolioValue)/previousPortfolioValue) * 100
                   
           return  [
            StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd),
            StatisticModel(title: "24h volume", value: data.volume),
            StatisticModel(title: "BTC Dominance", value: data.btcDominance),
            StatisticModel(title: "Porfolio value",
                           value: portfolioValue.asCurrencyWith2Decimals(),
                           percentageChange: percentageChange)
            ]

    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel],
                                             portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }

    func reloadData() async {
        
        coinDataService.getCoins()
        markerDataService.getData()
    }
}


extension HomeViewModel {
    enum SortOption {
        case rank, rankReversed, holding, holdingReversed, price, priceReversed
        
        var isByRank: Bool {
            switch self {
               case .rank, .rankReversed: return true
               default: return false
            }
        }
        
        var isByHolding: Bool {
            switch self {
               case .holding, .holdingReversed: return true
               default: return false
            }
        }
        
        var isByPrice: Bool {
            switch self {
               case .price, .priceReversed: return true
               default: return false
            }
        }
    }
}
