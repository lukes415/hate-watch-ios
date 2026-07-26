import SwiftUI

extension Color {
    /// Parses a 6-digit hex color string like "#004a7b" or "004a7b".
    /// Returns nil for malformed input so callers can fall back to a neutral color
    /// instead of crashing — team color data from the API is optional/imperfect.
    init?(hex: String) {
        let sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        guard sanitized.count == 6, let rgb = UInt64(sanitized, radix: 16) else { return nil }
        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255,
            green: Double((rgb & 0x00FF00) >> 8) / 255,
            blue: Double(rgb & 0x0000FF) / 255
        )
    }
}

extension Array where Element == Team {
    /// Looks up a team's primary color by id, falling back to systemGray4 when
    /// the team isn't found or its color data is missing/malformed. Shared by
    /// GameCardView's accent stripe and GameDetailView's header bar/prediction tint.
    func color(forTeamId id: Int) -> Color {
        guard let hex = first(where: { $0.id == id })?.color, let color = Color(hex: hex) else {
            return Color(.systemGray4)
        }
        return color
    }
}
