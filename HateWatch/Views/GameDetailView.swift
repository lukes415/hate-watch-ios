import SwiftUI

struct GameDetailView: View {
    let game: NextGame
    let allTeams: [Team]

    /// Formats a spread value for display alongside the picked team name.
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
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                matchupHeader

                // Prediction section comes first — it's the point of the app
                if let prediction = game.prediction,
                   let pickedTeam = allTeams.first(where: { $0.id == prediction.modelPickTeamId }) {
                    predictionSection(prediction: prediction, pickedTeam: pickedTeam)
                }

                gameInfoSection
            }
            .padding()
        }
        .navigationTitle("Game Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subviews

    private var matchupHeader: some View {
        VStack(spacing: 16) {
            HStack {
                VStack {
                    Text(game.awayTeam).font(.title2).bold()
                    Text("Away").font(.caption).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)

                Text("@").font(.title).foregroundStyle(.secondary)

                VStack {
                    Text(game.homeTeam).font(.title2).bold()
                    Text("Home").font(.caption).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }

            Divider()

            VStack(spacing: 8) {
                Label(game.date, systemImage: "calendar")
                Label("Week \(game.week)", systemImage: "sportscourt")
            }
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    @ViewBuilder
    private func predictionSection(prediction: PredictionDetail, pickedTeam: Team) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Model Pick")
                .font(.headline)

            Text(formattedSpread(game.lines?.spread, pickedTeamName: pickedTeam.name))
                .font(.title3)
                .fontWeight(.semibold)

            // Confidence bar. We show this instead of a raw percentage to give
            // a visceral sense of how certain the model is — 61% looks more
            // compelling as a bar than as a number.
            VStack(alignment: .leading, spacing: 4) {
                Text("\(Int(prediction.probCover * 100))% confidence")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(height: 8)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.blue)
                            .frame(width: geo.size.width * prediction.probCover, height: 8)
                    }
                }
                .frame(height: 8)
            }

            // Key factors — global importances from training, not per-game SHAP.
            if !prediction.topFactors.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Key factors")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    FlowLayout(spacing: 8) {
                        ForEach(prediction.topFactors, id: \.self) { factor in
                            Text(factor)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    @ViewBuilder
    private var gameInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Game Info")
                .font(.headline)

            if let venue = game.venue {
                VStack(alignment: .leading, spacing: 4) {
                    if let name = venue.name {
                        Label(name, systemImage: "building.2")
                    }
                    if let city = venue.city, let state = venue.state {
                        Text("\(city), \(state)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.leading, 28)
                    }
                    if let surface = venue.surface {
                        Text(surface.capitalized)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.leading, 28)
                    }
                }
            }

            if let weather = game.weather {
                weatherRow(weather)
            }

            if let spread = game.lines?.spread {
                Label("Spread: \(spread > 0 ? "+" : "")\(String(format: "%.1f", spread)) (home)",
                      systemImage: "chart.bar")
            }
        }
        .foregroundStyle(.secondary)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    @ViewBuilder
    private func weatherRow(_ weather: WeatherDetail) -> some View {
        // Condense temperature + conditions + wind into one line to keep the card compact
        let parts: [String] = [
            weather.temperature.map { "\($0)°F" },
            weather.conditions,
            weather.windMph.map { "\(Int($0)) mph wind" },
        ].compactMap { $0 }

        if !parts.isEmpty {
            Label(parts.joined(separator: " · "), systemImage: "cloud.sun")
        }
    }
}

// MARK: - FlowLayout

/// A simple wrapping layout for the key factors chips.
/// SwiftUI doesn't have a built-in flow layout pre-iOS 16, so we roll a minimal one.
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.map { $0.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0 }
                        .reduce(0) { $0 + $1 + spacing } - spacing
        return CGSize(width: proposal.width ?? 0, height: max(height, 0))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            let rowHeight = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            for subview in row {
                let size = subview.sizeThatFits(.unspecified)
                subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += rowHeight + spacing
        }
    }

    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubview]] {
        var rows: [[LayoutSubview]] = [[]]
        var x: CGFloat = 0
        let maxWidth = proposal.width ?? .infinity
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && !rows[rows.count - 1].isEmpty {
                rows.append([])
                x = 0
            }
            rows[rows.count - 1].append(subview)
            x += size.width + spacing
        }
        return rows
    }
}

#Preview {
    NavigationStack {
        GameDetailView(
            game: NextGame(
                id: "1", homeTeam: "Alabama", homeTeamId: 333,
                awayTeam: "Auburn", awayTeamId: 2,
                date: "2025-11-29T19:00:00Z", week: 14, season: 2025,
                venue: VenueDetail(name: "Bryant-Denny Stadium", city: "Tuscaloosa", state: "AL", surface: "grass"),
                weather: WeatherDetail(temperature: 58, conditions: "Partly Cloudy", windMph: 12),
                lines: LinesDetail(spread: -7.0),
                prediction: PredictionDetail(modelPickTeamId: 333, probCover: 0.61,
                                             topFactors: ["ELO rating", "Home field", "Rest advantage"])
            ),
            allTeams: [Team(id: 333, name: "Alabama", logoURL: nil, conference: "SEC")]
        )
    }
}
