//
//  HomeView.swift
//  Crypto
//
//  Created by Surya on 02/09/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio = false
    
    var body: some View {
        ZStack {
            // background layer 
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                headerView
                Spacer(minLength: 0)
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .toolbar(.hidden, for: .navigationBar)

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
}
