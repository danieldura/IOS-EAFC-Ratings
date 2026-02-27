//
//  PlayerEntity.swift
//  EAFC Ratings
//
//  Created by Daniel Dura on 25/2/26.
//

import Foundation
import SwiftData

// MARK: - SwiftData Entity

@Model
final class PlayerEntity {
    @Attribute(.unique) var id: Int
    var rank: Int
    var firstName: String
    var lastName: String
    var commonName: String
    var birthdate: Date?
    var height: Int
    var weight: Int
    var overallRating: Int

    // Position
    var positionId: String
    var positionShortLabel: String
    var positionLabel: String

    // Team
    var teamId: Int
    var teamLabel: String
    var teamImageUrl: String?

    // Nationality
    var nationalityId: Int
    var nationalityLabel: String
    var nationalityImageUrl: String?

    var avatarUrl: String?
    var shieldUrl: String?
    var skillMoves: Int
    var weakFootAbility: Int
    var preferredFoot: Int

    // Stats (flattened for SwiftData)
    var pace: Int
    var shooting: Int
    var passing: Int
    var dribbling: Int
    var defending: Int
    var physicality: Int

    var cachedAt: Date

    init(
        id: Int,
        rank: Int,
        firstName: String,
        lastName: String,
        commonName: String,
        birthdate: Date?,
        height: Int,
        weight: Int,
        overallRating: Int,
        positionId: String,
        positionShortLabel: String,
        positionLabel: String,
        teamId: Int,
        teamLabel: String,
        teamImageUrl: String?,
        nationalityId: Int,
        nationalityLabel: String,
        nationalityImageUrl: String?,
        avatarUrl: String?,
        shieldUrl: String?,
        skillMoves: Int,
        weakFootAbility: Int,
        preferredFoot: Int,
        pace: Int,
        shooting: Int,
        passing: Int,
        dribbling: Int,
        defending: Int,
        physicality: Int,
        cachedAt: Date
    ) {
        self.id = id
        self.rank = rank
        self.firstName = firstName
        self.lastName = lastName
        self.commonName = commonName
        self.birthdate = birthdate
        self.height = height
        self.weight = weight
        self.overallRating = overallRating
        self.positionId = positionId
        self.positionShortLabel = positionShortLabel
        self.positionLabel = positionLabel
        self.teamId = teamId
        self.teamLabel = teamLabel
        self.teamImageUrl = teamImageUrl
        self.nationalityId = nationalityId
        self.nationalityLabel = nationalityLabel
        self.nationalityImageUrl = nationalityImageUrl
        self.avatarUrl = avatarUrl
        self.shieldUrl = shieldUrl
        self.skillMoves = skillMoves
        self.weakFootAbility = weakFootAbility
        self.preferredFoot = preferredFoot
        self.pace = pace
        self.shooting = shooting
        self.passing = passing
        self.dribbling = dribbling
        self.defending = defending
        self.physicality = physicality
        self.cachedAt = cachedAt
    }
}

// MARK: - Mapper between Entity and Domain

extension PlayerEntity {

    func toDomain(fullStats: PlayerStats) -> Player {
        Player(
            id: id,
            rank: rank,
            firstName: firstName,
            lastName: lastName,
            commonName: commonName,
            birthdate: birthdate,
            height: height,
            weight: weight,
            overallRating: overallRating,
            position: Position(
                id: positionId,
                shortLabel: positionShortLabel,
                label: positionLabel
            ),
            alternatePositions: [],
            avatarUrl: avatarUrl,
            shieldUrl: shieldUrl,
            team: Team(
                id: teamId,
                label: teamLabel,
                imageUrl: teamImageUrl
            ),
            nationality: Nationality(
                id: nationalityId,
                label: nationalityLabel,
                imageUrl: nationalityImageUrl
            ),
            skillMoves: skillMoves,
            weakFootAbility: weakFootAbility,
            preferredFoot: FootPreference(rawValue: preferredFoot) ?? .right,
            stats: fullStats,
            playerAbilities: []
        )
    }

    static func fromDomain(_ player: Player) -> PlayerEntity {
        PlayerEntity(
            id: player.id,
            rank: player.rank,
            firstName: player.firstName,
            lastName: player.lastName,
            commonName: player.commonName,
            birthdate: player.birthdate,
            height: player.height,
            weight: player.weight,
            overallRating: player.overallRating,
            positionId: player.position.id,
            positionShortLabel: player.position.shortLabel,
            positionLabel: player.position.label,
            teamId: player.team.id,
            teamLabel: player.team.label,
            teamImageUrl: player.team.imageUrl,
            nationalityId: player.nationality.id,
            nationalityLabel: player.nationality.label,
            nationalityImageUrl: player.nationality.imageUrl,
            avatarUrl: player.avatarUrl,
            shieldUrl: player.shieldUrl,
            skillMoves: player.skillMoves,
            weakFootAbility: player.weakFootAbility,
            preferredFoot: player.preferredFoot.rawValue,
            pace: player.stats.pace,
            shooting: player.stats.shooting,
            passing: player.stats.passing,
            dribbling: player.stats.dribbling,
            defending: player.stats.defending,
            physicality: player.stats.physicality,
            cachedAt: Date()
        )
    }
}
