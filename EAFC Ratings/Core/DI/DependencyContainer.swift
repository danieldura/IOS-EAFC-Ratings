//
//  DependencyContainer.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation
import SwiftUI
import SwiftData

private struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue: DependencyContainer = .shared
}

// MARK: - Dependency Container

final class DependencyContainer: @unchecked Sendable {

    static let shared = DependencyContainer()

    private init() {}

    // MARK: - Model Container

    lazy var modelContainer: ModelContainer = {
        let schema = Schema([PlayerEntity.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: - Network

    lazy var networkService: NetworkServiceProtocol = {
        NetworkService()
    }()

    // MARK: - Data Sources

    lazy var remotePlayerDataSource: RemotePlayerDataSourceProtocol = {
        RemotePlayerDataSource(networkService: networkService)
    }()

    lazy var localPlayerDataSource: LocalPlayerDataSourceProtocol = {
        LocalPlayerDataSource(modelContainer: modelContainer)
    }()

    // MARK: - Repositories

    lazy var playerRepository: PlayerRepositoryProtocol = {
        PlayerRepository(
            remoteDataSource: remotePlayerDataSource,
            localDataSource: localPlayerDataSource
        )
    }()

    // MARK: - Use Cases

    lazy var getPlayersUseCase: GetPlayersUseCaseProtocol = {
        GetPlayersUseCase(repository: playerRepository)
    }()

    lazy var getPlayerDetailUseCase: GetPlayerDetailUseCaseProtocol = {
        GetPlayerDetailUseCase(repository: playerRepository)
    }()

    // MARK: - View Models

    @MainActor
    func makePlayerListViewModel() -> PlayerListViewModel {
        PlayerListViewModel(getPlayersUseCase: getPlayersUseCase)
    }
}

// MARK: - Environment Entry (iOS 26.2+ ready)

extension EnvironmentValues {
    @Entry var dependencies: DependencyContainer = .shared
}
