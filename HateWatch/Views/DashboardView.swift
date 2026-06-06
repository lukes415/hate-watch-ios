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
                        NavigationLink(destination: GameDetailView(game: game, allTeams: allTeams)) {
                            GameCard(game: game, allTeams: allTeams)
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
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// Formats an ISO 8601 date string to a human-readable game time.
    /// Example: "2025-11-29T19:00:00Z" → "Sat, Nov 29 · 7:00 PM ET"
    private func formatDate(_ dateString: String) -> String {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let iso2 = ISO8601DateFormatter()

        guard let date = iso.date(from: dateString) ?? iso2.date(from: dateString) else {
            return dateString
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d · h:mm a"
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        return formatter.string(from: date) + " ET"
    }
}
