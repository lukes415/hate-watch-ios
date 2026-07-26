//
//  HateWatchTests.swift
//  HateWatchTests
//
//  Created by Luke Schurman on 10/1/25.
//

import Testing
import SwiftUI
@testable import HateWatch

struct HateWatchTests {

    @Test func colorHexParsesWithHash() {
        #expect(Color(hex: "#004a7b") != nil)
    }

    @Test func colorHexParsesWithoutHash() {
        #expect(Color(hex: "004a7b") != nil)
    }

    @Test func colorHexReturnsNilForMalformedInput() {
        #expect(Color(hex: "not-a-color") == nil)
    }

    @Test func colorHexReturnsNilForWrongLength() {
        #expect(Color(hex: "abc") == nil)
    }

    @Test func teamDecodesColorFields() throws {
        let json = """
        {"id": 1, "name": "Air Force Falcons", "conference": "Mountain West",
         "logoURL": "https://example.com/1.png", "color": "#004a7b", "alternateColor": "#ffffff"}
        """.data(using: .utf8)!

        let team = try JSONDecoder().decode(Team.self, from: json)

        #expect(team.color == "#004a7b")
        #expect(team.alternateColor == "#ffffff")
    }

    @Test func teamDecodesWithoutColorFields() throws {
        let json = """
        {"id": 1, "name": "Air Force Falcons", "conference": "Mountain West",
         "logoURL": "https://example.com/1.png"}
        """.data(using: .utf8)!

        let team = try JSONDecoder().decode(Team.self, from: json)

        #expect(team.color == nil)
        #expect(team.alternateColor == nil)
    }

    @Test func teamArrayColorLookupFindsMatchingTeam() {
        let teams = [Team(id: 1, name: "Air Force", logoURL: nil, conference: nil, color: "#004a7b", alternateColor: "#ffffff")]

        #expect(teams.color(forTeamId: 1) == Color(hex: "#004a7b"))
    }

    @Test func teamArrayColorLookupFallsBackWhenTeamMissing() {
        let teams: [Team] = []

        #expect(teams.color(forTeamId: 999) == Color(.systemGray4))
    }

    @Test func teamArrayColorLookupFallsBackWhenColorMalformed() {
        let teams = [Team(id: 1, name: "Air Force", logoURL: nil, conference: nil, color: "not-a-color", alternateColor: nil)]

        #expect(teams.color(forTeamId: 1) == Color(.systemGray4))
    }

}
