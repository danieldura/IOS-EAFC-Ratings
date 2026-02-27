//
//  PlayerRepository.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation

final class PlayerRepository: PlayerRepositoryProtocol {

    private let remoteDataSource: RemotePlayerDataSourceProtocol
    private let localDataSource: LocalPlayerDataSourceProtocol

    init(
        remoteDataSource: RemotePlayerDataSourceProtocol,
        localDataSource: LocalPlayerDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func getPlayers(forceRefresh: Bool = false) async throws -> [Player] {
        // Strategy: Cache-first, then fetch from remote
        if !forceRefresh {
            let cachedPlayers = try await localDataSource.fetchAllPlayers()
            if !cachedPlayers.isEmpty {
                return cachedPlayers
            }
        }

        // Fetch from remote
        let playerDTOs = try await remoteDataSource.fetchPlayers()
        let players = playerDTOs.map { PlayerMapper.toDomain($0) }

        // Update cache
        try await localDataSource.clearAll()
        try await localDataSource.savePlayers(players)

        return players
    }

    func getPlayer(byId id: Int) async throws -> Player? {
        // Try local first
        if let cachedPlayer = try await localDataSource.fetchPlayer(byId: id) {
            return cachedPlayer
        }

        // If not in cache, fetch all from remote and find the player
        let players = try await getPlayers(forceRefresh: true)
        return players.first { $0.id == id }
    }
}
