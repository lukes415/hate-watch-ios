//struct GamePrediction: Codable, Identifiable {
//  let id: String        // map from game_id
//  let homeTeamId: Int
//  let awayTeamId: Int
//  let spread: Double
//  let probCover: Double
//  let modelPick: Bool
//}
//
//actor APIClient {
//  func predictions(season: Int, week: Int) async throws -> [GamePrediction] {
//    let url = URL(string: "<api>/predict?season=\(season)&week=\(week)")!
//    let (data, _) = try await URLSession.shared.data(from: url)
//    var items = try JSONDecoder().decode([GamePrediction].self, from: data)
//    // map game_id -> id etc.
//    return items
//  }
//}
