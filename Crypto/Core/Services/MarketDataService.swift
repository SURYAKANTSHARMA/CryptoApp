//
//  MarketDataService.swift
//  Crypto
//
//  Created by Surya on 14/10/23.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    func getData() {
        
        let url = URL(string: "https://api.coingecko.com/api/v3/global")!
        marketDataSubscription =
         NetworkManager.download(url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] globalData in
                self?.marketData = globalData.data
                self?.marketDataSubscription?.cancel()
            })
    }

}
