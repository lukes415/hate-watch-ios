import SwiftUI

struct DashboardView: View {
    let selectedTeamIds: Set<Int>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Mock data for now - replace with real API
                GameCard(
                    homeTeam: "Rutgers",
                    awayTeam: "Maryland",
                    date: "Nov 8, 2025 11:30 AM",
                    venue: "SHI Stadium"
                )
                
                GameCard(
                    homeTeam: "Texas Tech",
                    awayTeam: "BYU",
                    date: "Nov 8, 2025 9:00 AM",
                    venue: "Jones AT&T Stadium"
                )
                
                // Loop through selectedTeamIds and fetch real games
            }
            .padding()
        }
        .navigationTitle("My Teams")
    }
}
