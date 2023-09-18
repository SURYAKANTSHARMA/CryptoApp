//
//  CoinImageView.swift
//  Crypto
//
//  Created by Surya on 18/09/23.
//

import SwiftUI
import Combine

class ImageService {
    
    enum Error: LocalizedError {
        case badURL
        case downloadError(url: URL)
    }
    
    let urlString: String
    
    @Published var result: Result<Image, Error>?
    
    init(_ urlString: String) {
        self.urlString = urlString
    }
    
    func loadData()  {
        guard let url = URL(string: urlString) else {
            result = .failure(Error.badURL)
            return
        }
        
//        NetworkManager.download(url)
//            .tryMap { <#Data#> in
//                Image
//            }
//            .sink(receiveCompletion: NetworkManager.handleCompletion,
//                  receiveValue: { [weak self] coins in
//                self?.allcoins = coins
//                self?.coinsSubscription?.cancel()
//            })
    }
}

class CoinImageViewModel: ObservableObject {
    
    enum State {
        case loading
        case image(Image)
        case failure(Error)
    }
    
    @Published var state: State?

    let service: ImageService
    var anyCancellable: AnyCancellable?
    
    init(urlString: String) {
        state = .loading
        service = ImageService(urlString)
        anyCancellable = service.$result
            .sink { [weak self] result in
                guard let self = self, let result else { return }
                switch result {
                case .success(let image):
                    self.state = .image(image)
                case .failure(let error):
                    self.state = .failure(error)
                }
            }
    }
}

struct CoinImageView: View {
    let viewModel: CoinImageViewModel
    
    init(urlString: String) {
        self.viewModel = CoinImageViewModel(urlString: urlString)
    }
    
    var body: some View {
        Text("")
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(urlString: DeveloperPreview.instance.coin.image)
    }
}
