//
//  CoinRowView.swift
//  Crypto
//
//  Created by Surya on 02/09/23.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let shouldShowHoldingColoum: Bool
    
    var body: some View {
        HStack {
            leftColoumn
            Spacer()
            
            if shouldShowHoldingColoum {
                centerColoumn
                Spacer()
            }

            rightColoumn
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(
                coin: dev.coin,
                shouldShowHoldingColoum: true)
            .previewLayout(.sizeThatFits)
            
            CoinRowView(
                coin: dev.coin,
                shouldShowHoldingColoum: true)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)

        }
    }
}


extension CoinRowView {
    
    private var leftColoumn: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
//            Image(coin.image)
//                .foregroundColor(.black)
            Circle()
                .frame(width: 30, height:30)
            Text(coin.name)
            
        }
    }
    
    private var centerColoumn: some View {
        VStack {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
            Text("\(coin.currentHoldings ?? 0)")
        }
    }
    
    private var rightColoumn: some View {
        VStack {
            
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)

            Text(coin.priceChangePercentage24HInCurrency?.asPercentString() ?? "")
                .foregroundColor(
                    coin.priceChangePercentage24H >= 0 ?
                    Color.theme.green :
                        Color.theme.red
                )
                .frame(width: UIScreen.main.bounds.width/3.5, alignment: .trailing)
            
        }

    }
}
