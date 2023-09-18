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
    let service = CoinDataService()
    var anyCancellables = Set<AnyCancellable>()
    
    init() {        
        service.$allcoins
            .receive(on: RunLoop.main)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }.store(in: &anyCancellables)
            
    }
}
