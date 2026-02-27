//
//  PlayerRepositoryTests.swift
//  EAFC RatingsTests
//
//  Created by Daniel Dura on 27/2/26.
//

import Testing
import Foundation
@testable import EAFC_Ratings

struct PlayerRepositoryTests {

    @Test("Repository returns cached players first without calling remote")
    func testCacheFirstStrategy() async throws {

        let localMock = MockLocalDataSource()
        let remoteMock = MockRemoteDataSource()

        localMock.playersToReturn = [.mock]

        let repository = PlayerRepository(
            remoteDataSource: remoteMock,
            localDataSource: localMock
        )

        let result = try await repository.getPlayers(forceRefresh: false)

        #expect(result.count == 1)
        #expect(result.first?.firstName == "Messi")

        #expect(localMock.fetchAllCalledCount == 1, "Debería haber consultado el caché")
        #expect(remoteMock.fetchPlayersCalledCount == 0, "NO debería haber llamado a la API si el caché tenía datos")
    }

    @Test("Repository calls remote when forceRefresh is true even if cache exists")
    func testForceRefreshStrategy() async throws {

        let localMock = MockLocalDataSource()
        let remoteMock = MockRemoteDataSource()
        localMock.playersToReturn = [.mock]

        remoteMock.dtosToReturn = [.mock]

        let repository = PlayerRepository(remoteDataSource: remoteMock, localDataSource: localMock)

        // WHEN: Forzamos el refresco
        let result = try await repository.getPlayers(forceRefresh: true)

        #expect(result.first?.firstName == "Lionel Updated")
        #expect(remoteMock.fetchPlayersCalledCount == 1, "Debería haber llamado a la red")
        #expect(localMock.clearAllCalledCount == 1, "Debería haber limpiado el caché antiguo")
    }
}
