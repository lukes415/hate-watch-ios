import SwiftUI

struct DashboardView: View {
    let selectedTeamIds: Set<Int>
    let allTeams: [Team]
    
    @State private var games: [NextGame] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if isLoading {
                    ProgressView("Loading games...")
                        .padding()
                } else if let error = errorMessage {
                    VStack(spacing: 8) {
                        Text("Error loading games")
                            .font(.headline)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(.red)
                    .padding()
                } else if games.isEmpty {
                    Text("No upcoming games found")
                        .foregroundStyle(.secondary)
                        .padding()
                } else {
                    ForEach(games) { game in
                        NavigationLink(destination: GameDetailView(game: game)) {
                            GameCard(
                                homeTeam: game.homeTeam,
                                awayTeam: game.awayTeam,
                                date: formatDate(game.date),
                                venue: game.venue
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("My Teams")
        .task {
            await loadGames()
        }
    }
    
    private func loadGames() async {
        isLoading = true
        errorMessage = nil
        games = []
        
        let teamIdArray = Array(selectedTeamIds)
        
        do {
            games = try await APIService.shared.fetchNextGames(for: teamIdArray)
            print("Successfully loaded \(games.count) games")
        } catch {
            print("Error fetching games: \(error)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func formatDate(_ dateString: String) -> String {
        // For now, just return as-is
        // TODO: Format ISO date nicely
        return dateString
    }
}
