//
//  APIManager.swift
//  Pokedex-iOS
//
//  Created by Byron Mejia on 1/11/23.
//

import UIKit
import Combine

protocol HomeListStore {
    func readRegionList() -> Future<RegionResponse, Failure>
}

final class APIManager {
    
    private func request<T>(for path: String) -> Future<T, Failure> where T : Codable {
        let stringURL = "https://pokeapi.co/api/v2/\(path)"
        return Future { promise in
            
            guard let url = URL(string: stringURL) else {
                promise(.failure(.urlConstructError))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard let data = data, case .none = error else { promise(.failure(.urlConstructError)); return }
                do {
                    let decoder = JSONDecoder()
                    let searchResponse = try decoder.decode(T.self, from: data)
                    promise(.success(searchResponse))
                } catch {
                    promise(.failure(.APIError(error)))
                }
            }
            task.resume()
        }
    }
}

extension APIManager: HomeListStore {
    func readRegionList() -> Future<RegionResponse, Failure> {
        let urlString = "region"
        return request(for: urlString)
    }
}
