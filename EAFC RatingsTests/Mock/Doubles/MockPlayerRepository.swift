//
//  MockPlayerRepository.swift
//  EAFC RatingsTests
//
//  Created by Daniel Dura on 27/2/26.
//

import Foundation
@testable import EAFC_Ratings

final class MockPlayerRepository: PlayerRepositoryProtocol {

    // Propiedades para controlar el comportamiento del Mock
    var playersToReturn: [Player] = []
    var shouldFail: Bool = false
    var errorToThrow: Error = NetworkError.noData
    var delay: UInt64 = 10_000 // En nanosegundos para simular carga

    // Para verificar si se llamó al método (Verification)
    private(set) var getPlayersCalledCount = 0
    private(set) var forceRefreshReceived: Bool?

    func getPlayers(forceRefresh: Bool) async throws -> [Player] {
        getPlayersCalledCount += 1
        forceRefreshReceived = forceRefresh

        // Simular latencia de red si se especifica
        if delay > 0 {
            try? await Task.sleep(nanoseconds: delay)
        }

        // Simular Error (Estado: Sin Internet / Error API)
        if shouldFail {
            throw errorToThrow
        }

        // Simular Éxito
        return playersToReturn
    }

    func getPlayer(byId id: Int) async throws -> Player? {
        if shouldFail {
            throw errorToThrow
        }
        return playersToReturn.first { $0.id == id }
    }
}
