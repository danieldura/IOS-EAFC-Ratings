//
//  PlayerDTO+Mock.swift
//  EAFC RatingsTests
//
//  Created by Daniel Dura on 27/2/26.
//

import Foundation
@testable import EAFC_Ratings

extension PlayerDTO {
    static var mock: PlayerDTO {
        PlayerDTO(
            id: 123,
            rank: 1,
            firstName: "Lionel Updated",
            lastName: "Messi",
            commonName: "L. Messi",
            birthdate: "6/24/1987",
            height: 170,
            weight: 72,
            overallRating: 93,
            position: PositionDTO(id: "RW", shortLabel: "ED", label: "Extremo derecho"),
            alternatePositions: [],
            avatarUrl: "https://example.com/messi.jpg",
            shieldUrl: nil,
            team: TeamDTO(id: 1, label: "Inter Miami", imageUrl: nil),
            nationality: NationalityDTO(id: 1, label: "Argentina", imageUrl: nil),
            skillMoves: 5,
            weakFootAbility: 4,
            preferredFoot: 2,
            stats: [
                "pace": StatDTO(value: 85, diff: 0),
                "agility": StatDTO(value: 92, diff: 0),
                "jumping": StatDTO(value: 91, diff: 0),
                "stamina": StatDTO(value: 95, diff: 0),
                "strength": StatDTO(value: 35, diff: 0),
                "aggression": StatDTO(value: 65, diff: 0)
            ],
            playerAbilities: []
        )
    }
}
