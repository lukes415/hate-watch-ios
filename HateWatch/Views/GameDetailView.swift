import SwiftUI

struct GameDetailView: View {
    let game: NextGame
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Matchup header
                VStack(spacing: 16) {
                    HStack {
                        VStack {
                            Text(game.awayTeam)
                                .font(.title2)
                                .bold()
                            Text("Away")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Text("@")
                            .font(.title)
                            .foregroundStyle(.secondary)
                        
                        VStack {
                            Text(game.homeTeam)
                                .font(.title2)
                                .bold()
                            Text("Home")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Divider()
                    
                    VStack(spacing: 8) {
                        Label(game.date, systemImage: "calendar")
                        Label(game.venue, systemImage: "location")
                        Label("Week \(game.week)", systemImage: "sportscourt")
                    }
                    .foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Prediction section (placeholder for now)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Prediction")
                        .font(.headline)
                    
                    Text("Coming soon: Model prediction and analysis")
                        .foregroundStyle(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Game Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        GameDetailView(game: NextGame(
            id: "1",
            homeTeam: "Alabama",
            awayTeam: "Auburn",
            date: "Nov 30, 2024 7:00 PM",
            venue: "Bryant-Denny Stadium",
            week: 14,
            season: 2024
        ))
    }
}
