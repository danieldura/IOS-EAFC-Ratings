//
//  GetPlayerDetailUseCase.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation

protocol GetPlayerDetailUseCaseProtocol {
    func execute(playerId: Int) async throws -> Player?
}

final class GetPlayerDetailUseCase: GetPlayerDetailUseCaseProtocol {

    private let repository: PlayerRepositoryProtocol

    init(repository: PlayerRepositoryProtocol) {
        self.repository = repository
    }

    func execute(playerId: Int) async throws -> Player? {
        try await repository.getPlayer(byId: playerId)
    }
}
