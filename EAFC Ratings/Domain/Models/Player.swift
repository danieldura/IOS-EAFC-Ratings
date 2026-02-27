//
//  Player.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation

// MARK: - Domain Models

struct Player: Identifiable, Equatable, Hashable {
    let id: Int
    let rank: Int
    let firstName: String
    let lastName: String
    let commonName: String
    let birthdate: Date?
    let height: Int
    let weight: Int
    let overallRating: Int
    let position: Position
    let alternatePositions: [Position]
    let avatarUrl: String?
    let shieldUrl: String?
    let team: Team
    let nationality: Nationality
    let skillMoves: Int
    let weakFootAbility: Int
    let preferredFoot: FootPreference
    let stats: PlayerStats
    let playerAbilities: [PlayerAbility]
    var displayName: String {
        commonName.isEmpty ? "\(firstName) \(lastName)" : commonName
    }
}

struct Position: Identifiable, Equatable, Hashable {
    let id: String
    let shortLabel: String
    let label: String
}

struct Team: Identifiable, Equatable, Hashable {
    let id: Int
    let label: String
    let imageUrl: String?
}

struct Nationality: Identifiable, Equatable, Hashable {
    let id: Int
    let label: String
    let imageUrl: String?
}

struct PlayerStats: Equatable, Hashable {
    let pace: Int
    let shooting: Int
    let passing: Int
    let dribbling: Int
    let defending: Int
    let physicality: Int

    // Goalkeeper specific stats
    let diving: Int?
    let handling: Int?
    let kicking: Int?
    let positioning: Int?
    let reflexes: Int?

    // Detailed stats
    let acceleration: Int
    let sprintSpeed: Int
    let positioningAttack: Int
    let finishing: Int
    let shotPower: Int
    let longShots: Int
    let volleys: Int
    let penalties: Int
    let vision: Int
    let crossing: Int
    let freeKickAccuracy: Int
    let shortPassing: Int
    let longPassing: Int
    let curve: Int
    let agility: Int
    let balance: Int
    let reactions: Int
    let ballControl: Int
    let dribblingDetail: Int
    let composure: Int
    let interceptions: Int
    let headingAccuracy: Int
    let defAwareness: Int
    let standingTackle: Int
    let slidingTackle: Int
    let jumping: Int
    let stamina: Int
    let strength: Int
    let aggression: Int
}

struct PlayerAbility: Identifiable, Equatable, Hashable {
    let id: String
    let label: String
    let imageURL: String?
    let description: String
    let abilityType: AbilityType
}

struct AbilityType: Identifiable, Equatable, Hashable {
    let id: String
    let label: String
}

enum FootPreference: Int {
    case right = 1
    case left = 2

    var displayName: String {
        switch self {
        case .right: return "Derecha"
        case .left: return "Izquierda"
        }
    }
}
