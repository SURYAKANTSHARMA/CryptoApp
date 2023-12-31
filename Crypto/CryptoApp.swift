//
//  CryptoApp.swift
//  Crypto
//
//  Created by Surya on 02/09/23.
//

import SwiftUI

@main
struct CryptoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .toolbar(.hidden, for: .navigationBar)
            }.environmentObject(HomeViewModel())
        }
    }
}
