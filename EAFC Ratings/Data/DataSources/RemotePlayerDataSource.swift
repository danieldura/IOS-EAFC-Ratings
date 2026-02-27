//
//  RemotePlayerDataSource.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation

protocol RemotePlayerDataSourceProtocol {
    func fetchPlayers() async throws -> [PlayerDTO]
}

final class RemotePlayerDataSource: RemotePlayerDataSourceProtocol {

    private let networkService: NetworkServiceProtocol
    private let apiURL = "https://drop-api.ea.com/rating/ea-sports-fc?locale=es"

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchPlayers() async throws -> [PlayerDTO] {
        guard let url = URL(string: apiURL) else {
            throw NetworkError.invalidURL
        }

        let response: PlayersResponse = try await networkService.fetch(from: url)
        return response.items
    }
}
