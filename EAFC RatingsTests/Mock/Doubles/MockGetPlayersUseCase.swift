//
//  MockGetPlayersUseCase.swift
//  EAFC RatingsTests
//
//  Created by Daniel Dura on 27/2/26.
//

import Foundation
@testable import EAFC_Ratings

final class MockGetPlayersUseCase: GetPlayersUseCaseProtocol {
    var shouldFail = false
    var mockPlayers: [Player] = []
    var executeCallCount = 0

    func execute(forceRefresh: Bool) async throws -> [Player] {
        executeCallCount += 1

        if shouldFail {
            throw NetworkError.networkError(NSError(domain: "Test", code: -1, userInfo: nil))
        }

        return mockPlayers
    }
}
