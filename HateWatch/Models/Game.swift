import Foundation

// MARK: - Response wrapper

struct NextGamesResponse: Codable {
    let games: [NextGame]
    let teamsRequested: Int?
    let gamesFound: Int?

    enum CodingKeys: String, CodingKey {
        case games
        case teamsRequested = "teams_requested"
        case gamesFound = "games_found"
    }
}

// MARK: - Game

struct NextGame: Codable, Identifiable {
    let id: String
    let homeTeam: String
    let homeTeamId: Int?
    let awayTeam: String
    let awayTeamId: Int?
    let date: String
    let week: Int
    let season: Int

    // Enrichment fields — all optional so existing game cards work
    // without a prediction or game details (e.g., during API development)
    let venue: VenueDetail?
    let weather: WeatherDetail?
    let lines: LinesDetail?
    let prediction: PredictionDetail?

    enum CodingKeys: String, CodingKey {
        case id
        case homeTeam = "home_team"
        case homeTeamId = "home_team_id"
        case awayTeam = "away_team"
        case awayTeamId = "away_team_id"
        case date, venue, weather, lines, prediction, week, season
    }

    /// Kickoff time formatted in Eastern (the CFB broadcast standard), e.g. "Sat, Sep 5 · 4:00 PM ET".
    /// The API returns UTC ISO8601 (with fractional seconds); falls back to the raw string if unparseable.
    var formattedDate: String {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let isoNoFraction = ISO8601DateFormatter()

        guard let parsed = iso.date(from: date) ?? isoNoFraction.date(from: date) else {
            return date
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d · h:mm a"
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        return formatter.string(from: parsed) + " ET"
    }
}

// MARK: - Detail structs

struct VenueDetail: Codable {
    let name: String?
    let city: String?
    let state: String?
    let surface: String?
}

struct WeatherDetail: Codable {
    let temperature: Int?
    let conditions: String?
    let windMph: Double?

    enum CodingKeys: String, CodingKey {
        case temperature, conditions
        case windMph = "wind_mph"
    }
}

struct LinesDetail: Codable {
    let spread: Double?
}

struct PredictionDetail: Codable {
    /// Team ID of the model's pick. Resolve against fbs_teams.json for name/logo —
    /// returning an ID (not a string) avoids encoding team names in the API response.
    let modelPickTeamId: Int
    /// Probability that the picked team covers. Always represents the picked team,
    /// not always the home team — model_loader flips it when picking the away team.
    let probCover: Double
    /// Global feature importances from training time (same for every game).
    let topFactors: [String]

    enum CodingKeys: String, CodingKey {
        case modelPickTeamId = "model_pick_team_id"
        case probCover = "prob_cover"
        case topFactors = "top_factors"
    }
}
