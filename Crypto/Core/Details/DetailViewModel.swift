//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Surya on 04/11/23.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatics: [StatisticModel] = []
    @Published var additionalStatics: [StatisticModel] = []

    let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    @Published internal var coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin 
        coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscriber()
    }
    
    private func addSubscriber() {
        coinDetailDataService
            .$coinDetail
            .combineLatest($coin)
            .receive(on: DispatchQueue.main)
            .map(mapToOverViewAndStatics)
            .sink { [weak self] returnedArray  in
                self?.overviewStatics = returnedArray.overviewStatics
                self?.additionalStatics = returnedArray.additionalStatics
            }.store(in: &cancellables)
    }
    
    private func mapToOverViewAndStatics(coinDetailModel: CoinDetailModel?,
                                         coinModel: CoinModel) -> (overviewStatics: [StatisticModel],
                                                                   additionalStatics: [StatisticModel]) {
        //overview:
        let overViewArray = overViewArray(coinModel)
        // additional
        
        let additionalArray: [StatisticModel] = getAdditionalArray(coinDetailModel: coinDetailModel,
                                                                   coinModel: coinModel)

        return (overViewArray, additionalArray)

    }
    
    private func overViewArray(_ coinModel: CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price",
                                       value: price,
                                       percentageChange: pricePercentageChange)
        
        let markerCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChanged = coinModel.marketCapChangePercentage24H
        let marketStat = StatisticModel(title: "Market Capitalization",
                                        value: markerCap,
                                        percentageChange: marketCapChanged)
                 
        let rank = coinModel.rank
        let rankStat = StatisticModel(title: "Rank", value: "\(rank)")
        
        let volume = (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "volume", value: volume)
        
        
        let overviewArray: [StatisticModel] = [
            priceStat,
            marketStat,
            rankStat,
            volumeStat
        ]
        
        return overviewArray

    }
    
    private func getAdditionalArray(coinDetailModel: CoinDetailModel?,
                                 coinModel: CoinModel) -> [StatisticModel] {
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + ((coinModel.marketCapChange24H?.formattedWithAbbreviations()) ?? "")
        let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change",
                                                 value: marketCapChange,
                                                 percentageChange: marketCapPercentChange2)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)

        return [
            highStat,
            lowStat,
            priceChangeStat,
            marketCapChangeStat,
            blockStat,
            hashingStat
        ]
    }
}
