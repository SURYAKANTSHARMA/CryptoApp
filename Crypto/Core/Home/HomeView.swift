//
//  HomeView.swift
//  Crypto
//
//  Created by Surya on 02/09/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio = false
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            // background layer 
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                headerView
                coloumnTitles
                
                if !showPortfolio {
                    allCointList
                     .transition(.move(edge: .leading))
                } else {
                    porfolioCointList
                    .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .toolbar(.hidden, for: .navigationBar)
            .environmentObject(HomeViewModel())
    }
}

extension HomeView {
    var headerView: some View  {
        HStack {
            CircleButton(iconName: showPortfolio ? "plus" : "info")
                .background {
                    CircleButtonAnimationView(
                        isAnimating: $showPortfolio)
                }
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
            
            Spacer()
            CircleButton(iconName: "chevron.right")
                .rotationEffect(.degrees(showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation {
                        showPortfolio.toggle()
                    }
                }
        }.padding(.horizontal)
    }
    
    var allCointList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin,
                            shouldShowHoldingColoum: false)
            }
        }.listStyle(.plain)

    }
    
    var porfolioCointList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin,
                            shouldShowHoldingColoum: true)
            }
        }.listStyle(.plain)
    }
    
    var coloumnTitles: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPortfolio {
                Text("Holding")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width/3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }

}

