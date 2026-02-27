//
//  MockLocalDataSource.swift
//  EAFC RatingsTests
//
//  Created by Daniel Dura on 27/2/26.
//

import Foundation
@testable import EAFC_Ratings

final class MockLocalDataSource: LocalPlayerDataSourceProtocol {
    // Propiedades para configurar el comportamiento
    var playersToReturn: [Player] = []
    var shouldFail: Bool = false

    // Propiedades para verificar llamadas (Spy)
    private(set) var savePlayersCalledCount = 0
    private(set) var fetchAllCalledCount = 0
    private(set) var clearAllCalledCount = 0
    private(set) var lastSavedPlayers: [Player] = []

    func savePlayers(_ players: [Player]) async throws {
        savePlayersCalledCount += 1
        lastSavedPlayers = players
        if shouldFail { throw NSError(domain: "LocalCache", code: 1) }
        playersToReturn = players // Simulamos que se guardan
    }

    func fetchAllPlayers() async throws -> [Player] {
        fetchAllCalledCount += 1
        if shouldFail { throw NSError(domain: "LocalCache", code: 2) }
        return playersToReturn
    }

    func fetchPlayer(byId id: Int) async throws -> Player? {
        if shouldFail { throw NSError(domain: "LocalCache", code: 3) }
        return playersToReturn.first { $0.id == id }
    }

    func clearAll() async throws {
        clearAllCalledCount += 1
        if shouldFail { throw NSError(domain: "LocalCache", code: 4) }
        playersToReturn = []
    }
}
