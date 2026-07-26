import Foundation

@MainActor
class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:8000/v1"
    
    func fetchNextGames(for teamIds: [Int]) async throws -> [NextGame] {
        let idsString = teamIds.map(String.init).joined(separator: ",")
        let urlString = "\(baseURL)/teams/next-game?team_ids=\(idsString)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(NextGamesResponse.self, from: data)
        return decoded.games
    }
}
