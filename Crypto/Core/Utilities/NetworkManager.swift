//
//  NetworkManager.swift
//  Crypto
//
//  Created by Surya on 18/09/23.
//

import Combine
import Foundation

class NetworkManager {
    
    enum NetworkingError: LocalizedError {
        case badServerResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badServerResponse(let url):
               return "🔥 bad response from : \(url)"
            case .unknown:
                return "⚠️ something went wrong"
            }
        }
    }
    
    static func download(_ url: URL) -> AnyPublisher<Data, Error> {
         URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { try handleResponse($0, url) }
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(output:  Subscribers.Completion<Error>) {
        
        switch output {
        case .finished: break
        case .failure(let error):
            print(error.localizedDescription)
            print(error)
        }

    }
    
    static func handleResponse(_ output: URLSession.DataTaskPublisher.Output, _ url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300  else {
               throw NetworkingError.badServerResponse(url: url)
            }
        return output.data
    }
    
}
