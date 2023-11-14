//
//  CoinDetailDataService.swift
//  Crypto
//
//  Created by Surya on 04/11/23.
//

import Combine
import Foundation

class CoinDetailDataService {
    
    @Published var coinDetail: CoinDetailModel?
    var coinsSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        self.getDetail()
    }
    
    func getDetail() {
        // https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false
        
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")!
        
        coinsSubscription =
        NetworkManager.download(url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] coinDetail in
                self?.coinDetail = coinDetail
                self?.coinsSubscription?.cancel()
            })
    }
    
}
