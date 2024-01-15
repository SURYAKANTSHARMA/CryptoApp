//
//  DetailView.swift
//  Crypto
//
//  Created by Surya on 01/11/23.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin {
                DetailView(coin: coin)
            }
        }
    }
    
}

struct DetailView: View {
    
    @StateObject var viewModel: DetailViewModel
    private let coloumns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
     
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: viewModel.coin)
                    .padding(.vertical)
                VStack(spacing: 20) {
                    Text("")
                    overView
                    Divider()
                    overViewGrid
                    Divider()
                    additionalTitle
                    additionalGrid
                }
                .padding(.horizontal )
            }
        }.navigationTitle(viewModel.coin.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    navigationTrailingItem
                }
            }
    }

    init(coin: CoinModel) {
        self._viewModel = 
        StateObject(wrappedValue:
            DetailViewModel(
                coin: coin)
        )
        print("Init called with coin")
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}


extension DetailView {
    
   private var navigationTrailingItem: some View {
        HStack {
            Text(viewModel.coin.name)
            CoinImageView(urlString: viewModel.coin.image)
        }
   }
    
   private var overView: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overViewGrid: some View {
        LazyVGrid(
            columns: coloumns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(viewModel.overviewStatics) { stat in
                    StaticsticView(
                        stat: stat)
                }
        })

    }
    
    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)

    }
    
    private var additionalGrid: some View {
        LazyVGrid(
              columns: coloumns,
              alignment: .leading,
              spacing: spacing,
              pinnedViews: [],
              content: {
                  ForEach(viewModel.additionalStatics) { stat in
                      StaticsticView(
                          stat: stat)
                  }
          })
    }
}
