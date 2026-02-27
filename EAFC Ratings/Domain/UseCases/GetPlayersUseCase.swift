//
//  GetPlayersUseCase.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation

protocol GetPlayersUseCaseProtocol {
    func execute(forceRefresh: Bool) async throws -> [Player]
}

final class GetPlayersUseCase: GetPlayersUseCaseProtocol {

    private let repository: PlayerRepositoryProtocol

    init(repository: PlayerRepositoryProtocol) {
        self.repository = repository
    }

    func execute(forceRefresh: Bool = false) async throws -> [Player] {
        try await repository.getPlayers(forceRefresh: forceRefresh)
    }
}
