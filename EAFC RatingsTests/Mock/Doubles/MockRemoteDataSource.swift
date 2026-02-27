//
//  MockRemoteDataSource.swift
//  EAFC RatingsTests
//
//  Created by Daniel Dura on 27/2/26.
//

import Foundation
@testable import EAFC_Ratings

final class MockRemoteDataSource: RemotePlayerDataSourceProtocol {
    // Configuración de respuesta
    var dtosToReturn: [PlayerDTO] = []
    var shouldFail: Bool = false

    // Verificación de llamadas
    private(set) var fetchPlayersCalledCount = 0

    func fetchPlayers() async throws -> [PlayerDTO] {
        fetchPlayersCalledCount += 1

        if shouldFail {
            throw NSError(domain: "Network", code: -1009) // Simula sin internet
        }

        return dtosToReturn
    }
}
