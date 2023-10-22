//
//  PortfolioView.swift
//  Crypto
//
//  Created by Surya on 14/10/23.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var quantityText: String = ""
    @State private var showCheckMark = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $viewModel.searchText)
                        .padding()
                    coinLogoList
                    
                    if viewModel.selectedCoin != nil {
                        portfolioInputSection
                    }
                }
                
            }
        }.navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
        }
      )
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PortfolioView()
                .environmentObject(dev.homeVM)
        }
    }
}

extension PortfolioView {
    var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .onTapGesture {
                            viewModel.selectedCoin = coin
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(viewModel.selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
                        }
                }
            }.padding(.vertical, 4)
        }.padding(.leading)
    }
    
    func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (viewModel.selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(viewModel.selectedCoin?.symbol.uppercased() ?? "" ): ")
                Spacer()
                Text(viewModel.selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            
            Divider()
            
            HStack {
                Text("Amount Holding:")
                Spacer()
                TextField("ex 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current Value: ")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
            
        }
        .padding()
        .font(.headline)
    }
    
    var trailingNavBarButtons: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1 : 0 )
            Button(action: {
                
            },
                   label: {
                Text("Save".uppercased())
            })
            .opacity(viewModel.selectedCoin != nil && viewModel.selectedCoin?.currentHoldings != Double(quantityText) ? 1 : 0)
        }.font(.headline)
    }
  
    
    func saveButtonPressed() {
        guard let selectedCoin = viewModel.selectedCoin else { return }
        
        // Save to porfolio
        
        
        // show checkmark
        
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        viewModel.selectedCoin = nil
        viewModel.searchText = ""
    }
}
