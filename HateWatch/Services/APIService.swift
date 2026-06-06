import Foundation

@MainActor
class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:8000/v1"
    
    func fetchNextGames(for teamIds: [Int]) async throws -> [NextGame] {
        let idsString = teamIds.map(String.init).joined(separator: ",")
        print(teamIds)
        let urlString = "\(baseURL)/teams/next-game?team_ids=\(idsString)"
        
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
