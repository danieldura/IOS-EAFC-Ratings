//
//  LocalPlayerDataSource.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation
import SwiftData

protocol LocalPlayerDataSourceProtocol {
    func savePlayers(_ players: [Player]) async throws
    func fetchAllPlayers() async throws -> [Player]
    func fetchPlayer(byId id: Int) async throws -> Player?
    func clearAll() async throws
}

final class LocalPlayerDataSource: LocalPlayerDataSourceProtocol {

    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelContext = ModelContext(modelContainer)
    }

    func savePlayers(_ players: [Player]) async throws {
        for player in players {
            let entity = PlayerEntity.fromDomain(player)
            modelContext.insert(entity)
        }
        try modelContext.save()
    }

    func fetchAllPlayers() async throws -> [Player] {
        let descriptor = FetchDescriptor<PlayerEntity>(
            sortBy: [SortDescriptor(\.rank, order: .forward)]
        )
        let entities = try modelContext.fetch(descriptor)

        // Create basic stats since we only cache main stats
        return entities.map { entity in
            let stats = PlayerStats(
                pace: entity.pace,
                shooting: entity.shooting,
                passing: entity.passing,
                dribbling: entity.dribbling,
                defending: entity.defending,
                physicality: entity.physicality,
                diving: nil,
                handling: nil,
                kicking: nil,
                positioning: nil,
                reflexes: nil,
                acceleration: 0,
                sprintSpeed: 0,
                positioningAttack: 0,
                finishing: 0,
                shotPower: 0,
                longShots: 0,
                volleys: 0,
                penalties: 0,
                vision: 0,
                crossing: 0,
                freeKickAccuracy: 0,
                shortPassing: 0,
                longPassing: 0,
                curve: 0,
                agility: 0,
                balance: 0,
                reactions: 0,
                ballControl: 0,
                dribblingDetail: 0,
                composure: 0,
                interceptions: 0,
                headingAccuracy: 0,
                defAwareness: 0,
                standingTackle: 0,
                slidingTackle: 0,
                jumping: 0,
                stamina: 0,
                strength: 0,
                aggression: 0
            )
            return entity.toDomain(fullStats: stats)
        }
    }

    func fetchPlayer(byId id: Int) async throws -> Player? {
        let predicate = #Predicate<PlayerEntity> { entity in
            entity.id == id
        }

        let descriptor = FetchDescriptor<PlayerEntity>(predicate: predicate)
        let entities = try modelContext.fetch(descriptor)

        guard let entity = entities.first else { return nil }

        let stats = PlayerStats(
            pace: entity.pace,
            shooting: entity.shooting,
            passing: entity.passing,
            dribbling: entity.dribbling,
            defending: entity.defending,
            physicality: entity.physicality,
            diving: nil,
            handling: nil,
            kicking: nil,
            positioning: nil,
            reflexes: nil,
            acceleration: 0,
            sprintSpeed: 0,
            positioningAttack: 0,
            finishing: 0,
            shotPower: 0,
            longShots: 0,
            volleys: 0,
            penalties: 0,
            vision: 0,
            crossing: 0,
            freeKickAccuracy: 0,
            shortPassing: 0,
            longPassing: 0,
            curve: 0,
            agility: 0,
            balance: 0,
            reactions: 0,
            ballControl: 0,
            dribblingDetail: 0,
            composure: 0,
            interceptions: 0,
            headingAccuracy: 0,
            defAwareness: 0,
            standingTackle: 0,
            slidingTackle: 0,
            jumping: 0,
            stamina: 0,
            strength: 0,
            aggression: 0
        )

        return entity.toDomain(fullStats: stats)
    }

    func clearAll() async throws {
        try modelContext.delete(model: PlayerEntity.self)
        try modelContext.save()
    }
}
