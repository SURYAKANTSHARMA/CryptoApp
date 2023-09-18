//
//  CoinDataService.swift
//  Crypto
//
//  Created by Surya on 18/09/23.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allcoins: [CoinModel] = []
    var coinsSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins() {
//    https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
  
        
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")!
        
        coinsSubscription =
         NetworkManager.download(url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] coins in
                self?.allcoins = coins
                self?.coinsSubscription?.cancel()
            })
    }
    
}
