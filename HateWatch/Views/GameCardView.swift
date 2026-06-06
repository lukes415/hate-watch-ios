import SwiftUI

struct GameCard: View {
    let game: NextGame
    let allTeams: [Team]

    /// Formats the spread for display: -7.0 → "Alabama -7", +3.5 → "Auburn +3.5"
    private func formattedSpread(_ spread: Double?, pickedTeamName: String) -> String {
        guard let spread = spread else { return pickedTeamName }
        let absSpread = abs(spread)
        let formatted = absSpread.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(absSpread))
            : String(format: "%.1f", absSpread)
        let sign = spread < 0 ? "-" : "+"
        return "\(pickedTeamName) \(sign)\(formatted)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Matchup
            HStack {
                VStack(alignment: .leading) {
                    Text(game.awayTeam)
                        .font(.headline)
                    Text("@")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(game.homeTeam)
                        .font(.headline)
                }

                Spacer()

                // Prediction badge — only shown when the model has a pick.
                // Uses team ID to look up the name locally rather than
                // relying on the API to send a name string.
                if let prediction = game.prediction,
                   let team = allTeams.first(where: { $0.id == prediction.modelPickTeamId }) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(formattedSpread(game.lines?.spread, pickedTeamName: team.name))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("\(Int(prediction.probCover * 100))% confidence")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Divider()

            // Game details
            VStack(alignment: .leading, spacing: 4) {
                Label(game.date, systemImage: "calendar")
                    .font(.subheadline)
                if let venueName = game.venue?.name {
                    Label(venueName, systemImage: "location")
                        .font(.subheadline)
                }
            }
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    GameCard(
        game: NextGame(
            id: "1", homeTeam: "Alabama", homeTeamId: 333,
            awayTeam: "Auburn", awayTeamId: 2, date: "2025-11-29T19:00:00Z",
            week: 14, season: 2025, venue: nil, weather: nil, lines: nil, prediction: nil
        ),
        allTeams: []
    )
    .padding()
}
