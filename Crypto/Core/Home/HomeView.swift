//
//  HomeView.swift
//  Crypto
//
//  Created by Surya on 02/09/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio = false // animate right
    @State private var showPortfolioView = false // new sheet

    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            // background layer 
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    NavigationStack {
                        PortfolioView()
                            .environmentObject(viewModel)
                    }
                }
            VStack {
                headerView
                HomeStatsView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $viewModel.searchText)
                    .padding()
                
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
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
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
            
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.reloadData()
        }
            
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
            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortOption.isByRank ? 1 : 0)
                    .rotation3DEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180), axis: (x: 1, y: 0, z: 0))
            }.onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }
            
            Spacer()
            if showPortfolio {
                HStack {
                    Text("Holding")
                    Image(systemName: "chevron.down")
                        .opacity(viewModel.sortOption.isByHolding ? 1 : 0)
                        .rotation3DEffect(Angle(degrees: viewModel.sortOption == .holding ? 0 : 180), axis: (x: 1, y: 0, z: 0))
                }.onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = viewModel.sortOption == .holding ? .holdingReversed : .holding
                    }
                }
            }
            
            HStack {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortOption.isByPrice ? 1 : 0)
                    .rotation3DEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180), axis: (x: 1, y: 0, z: 0))
            }.frame(width: UIScreen.main.bounds.width/3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
                }
            }

        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }

}

