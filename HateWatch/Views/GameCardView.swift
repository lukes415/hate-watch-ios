import SwiftUI

struct GameCard: View {
    let homeTeam: String
    let awayTeam: String
    let date: String
    let venue: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Matchup
            HStack {
                VStack(alignment: .leading) {
                    Text(awayTeam)
                        .font(.headline)
                    Text("@")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(homeTeam)
                        .font(.headline)
                }
                
                Spacer()
                
                // Quick prediction indicator (enhance later)
                VStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text("Prediction")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            
            Divider()
            
            // Game details
            VStack(alignment: .leading, spacing: 4) {
                Label(date, systemImage: "calendar")
                    .font(.subheadline)
                Label(venue, systemImage: "location")
                    .font(.subheadline)
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
        homeTeam: "Alabama",
        awayTeam: "Auburn",
        date: "Nov 30, 2024 7:00 PM",
        venue: "Bryant-Denny Stadium"
    )
    .padding()
}
