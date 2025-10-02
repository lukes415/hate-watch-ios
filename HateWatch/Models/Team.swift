//
//  Team.swift
//  HateWatch
//
//  Created by Luke Schurman on 10/1/25.
//


import Foundation

struct Team: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let logoURL: URL
    let conference: String?

    enum CodingKeys: String, CodingKey {
        case id, name, conference
        case logoURL = "logoURL"
    }
}
