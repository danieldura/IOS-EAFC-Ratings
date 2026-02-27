//
//  Player+Mock.swift
//  EAFC RatingsTests
//
//  Created by Daniel Dura on 27/2/26.
//

import Foundation
@testable import EAFC_Ratings

extension Player {
    static var mock: Player {
        Player(
            id: 1,
            rank: 1,
            firstName: "Messi",
            lastName: "Last",
            commonName: "Player",
            birthdate: Date(),
            height: 180,
            weight: 75,
            overallRating: 85,
            position: Position(id: "ST", shortLabel: "ST", label: "Striker"),
            alternatePositions: [],
            avatarUrl: nil,
            shieldUrl: nil,
            team: Team(id: 1, label: "Test Team", imageUrl: nil),
            nationality: Nationality(id: 1, label: "Test Country", imageUrl: nil),
            skillMoves: 4,
            weakFootAbility: 3,
            preferredFoot: .right,
            stats: PlayerStats(
                pace: 85, shooting: 80, passing: 75, dribbling: 82, defending: 40, physicality: 70,
                diving: nil, handling: nil, kicking: nil, positioning: nil, reflexes: nil,
                acceleration: 85, sprintSpeed: 85, positioningAttack: 80, finishing: 80,
                shotPower: 78, longShots: 75, volleys: 72, penalties: 80, vision: 75,
                crossing: 70, freeKickAccuracy: 65, shortPassing: 75, longPassing: 70,
                curve: 70, agility: 82, balance: 80, reactions: 85, ballControl: 82,
                dribblingDetail: 82, composure: 78, interceptions: 40, headingAccuracy: 60,
                defAwareness: 35, standingTackle: 38, slidingTackle: 35, jumping: 70,
                stamina: 75, strength: 70, aggression: 60
            ),
            playerAbilities: []
        )
    }

    static func createMockPlayers(count: Int = 1) -> [Player] {
        (0..<count).map { index in
            Player(
                id: 1,
                rank: index + 1,
                firstName: "First",
                lastName: "Last",
                commonName: "Player \(index)",
                birthdate: Date(),
                height: 180,
                weight: 75,
                overallRating: 85,
                position: Position(id: "ST", shortLabel: "ST", label: "Striker"),
                alternatePositions: [],
                avatarUrl: nil,
                shieldUrl: nil,
                team: Team(id: 1, label: "Test Team", imageUrl: nil),
                nationality: Nationality(id: 1, label: "Test Country", imageUrl: nil),
                skillMoves: 4,
                weakFootAbility: 3,
                preferredFoot: .right,
                stats: PlayerStats(
                    pace: 85, shooting: 80, passing: 75, dribbling: 82, defending: 40, physicality: 70,
                    diving: nil, handling: nil, kicking: nil, positioning: nil, reflexes: nil,
                    acceleration: 85, sprintSpeed: 85, positioningAttack: 80, finishing: 80,
                    shotPower: 78, longShots: 75, volleys: 72, penalties: 80, vision: 75,
                    crossing: 70, freeKickAccuracy: 65, shortPassing: 75, longPassing: 70,
                    curve: 70, agility: 82, balance: 80, reactions: 85, ballControl: 82,
                    dribblingDetail: 82, composure: 78, interceptions: 40, headingAccuracy: 60,
                    defAwareness: 35, standingTackle: 38, slidingTackle: 35, jumping: 70,
                    stamina: 75, strength: 70, aggression: 60
                ),
                playerAbilities: []
            )
        }
    }
}
