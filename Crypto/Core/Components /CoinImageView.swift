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
    
    var subscription: AnyCancellable?
    
    @Published var result: Result<UIImage, Error>?
    
    func downloadImage(urlString: String)  {
        guard let url = URL(string: urlString) else {
            result = .failure(Error.badURL)
            return
        }
        
        subscription = NetworkManager.download(url)
            .tryMap { data in
                UIImage(data: data)
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

    let service: ImageService = ImageService()
    let localFileManager: LocalFileManager = LocalFileManager.shared
    var anyCancellable: AnyCancellable?
    private let folderName = "ImagesCache"
    private let imageName: String
    
    init(urlString: String) {
        state = .loading
        imageName = URL(string: urlString)?.lastPathComponent ?? ""
        getImage(urlString: urlString)
    }
    
    func getImage(urlString: String) {
        if let  image = localFileManager.getImage(
            imageName: imageName, folderName: folderName)  {
            self.state = .image(Image(uiImage: image))
            return
        }
        
        anyCancellable = service.$result
            .receive(on: RunLoop.main)
            .sink { [weak self] result in
                guard let self = self, let result else { return }
                switch result {
                case .success(let image):
                    self.state = .image(Image(uiImage: image))
                    localFileManager.saveImage(image: image, imageName: imageName, folderName: folderName)
                case .failure(let error):
                    self.state = .failure(error)
                }
            }
        
        service.downloadImage(urlString: urlString)
    }
}

struct CoinImageView: View {
    @StateObject var viewModel: CoinImageViewModel
    
    init(urlString: String) {
        _viewModel = StateObject(
            wrappedValue: CoinImageViewModel(urlString: urlString)
        )
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
