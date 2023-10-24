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

    let coinDataService = CoinDataService()
    let markerDataService = MarketDataService()
    let portfolioServiceContainer = PortfolioServiceContainer()
    
    var anyCancellables = Set<AnyCancellable>()
    
    init() {
        let searchSharedPublisher = $searchText.share()

        searchSharedPublisher
            .debounce(for: 0.3, scheduler: DispatchQueue.global()) 
            .combineLatest(coinDataService.$allcoins)
            .map(filterAllCoinsUsing)
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
                self?.portfolioCoins = porfolioCoins
            }.store(in: &anyCancellables)
   
    }
    
    public func updatePortfolio(coin: CoinModel,
                                amount: Double) {
        portfolioServiceContainer.updatePortfolio(coin: coin, amount: amount)
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

}
