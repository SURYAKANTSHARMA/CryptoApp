//
//  CryptoApp.swift
//  Crypto
//
//  Created by Surya on 02/09/23.
//

import SwiftUI

@main
struct CryptoApp: App {
    @StateObject var viewModel = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .toolbar(.hidden, for: .navigationBar)
            }.environmentObject(viewModel)
        }
    }
}
