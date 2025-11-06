import Foundation

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

struct NextGame: Codable, Identifiable {
    let id: String
    let homeTeam: String
    let awayTeam: String
    let date: String
    let venue: String
    let week: Int
    let season: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case date, venue, week, season
    }
}

@MainActor
class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:8000/v1"
    
    func fetchNextGames(for teamIds: [Int]) async throws -> [NextGame] {
        let idsString = teamIds.map(String.init).joined(separator: ",")
        print(teamIds)
        let urlString = "\(baseURL)/teams/next-games?team_ids=\(idsString)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Debug: print response
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code: \(httpResponse.statusCode)")
        }
        
        let decoded = try JSONDecoder().decode(NextGamesResponse.self, from: data)
        return decoded.games
    }
}
