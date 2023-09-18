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
    var subscription: AnyCancellable?
    
    @Published var result: Result<Image, Error>?
    
    init(_ urlString: String) {
        self.urlString = urlString
        downloadImage()
    }
    
    func downloadImage()  {
        guard let url = URL(string: urlString) else {
            result = .failure(Error.badURL)
            return
        }
        
        subscription = NetworkManager.download(url)
            .tryMap { data in
                if let image = UIImage(data: data) {
                    return Image(uiImage: image)
                }
                return nil
            }
            .compactMap { $0 }
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] image in
                self?.result = .success(image)
                self?.subscription?.cancel()
            })
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
    @StateObject var viewModel: CoinImageViewModel
    
    init(urlString: String) {
        _viewModel = StateObject(wrappedValue: CoinImageViewModel(urlString: urlString))
    }
    
    var body: some View {
        switch viewModel.state {
        case .image(let image):
            image.resizable()
                .frame(width: 30, height:30)
                .scaledToFit()
        case .loading:
            ProgressView()
        case .failure(_), .none:
            Image(systemName: "questionMark")
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(urlString: DeveloperPreview.instance.coin.image)
    }
}
