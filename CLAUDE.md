# hate-watch-ios

SwiftUI iOS app for tracking upcoming games of your most-hated college football teams. Connects to `cfb-ats-api` for live game data.

## Running

Open `HateWatch.xcodeproj` in Xcode and run on simulator or device. The app expects `cfb-ats-api` running locally at `http://localhost:8000`.

## Architecture

- `Views/TeamListView.swift` — team browser with search; loads teams from bundled `fbs_teams.json`; persists selected team IDs
- `Views/DashboardView.swift` — shows next upcoming game card for each selected team; calls `/v1/teams/next-game`
- `Views/GameCardView.swift` — reusable card component; shows prediction badge with picked team and confidence
- `Views/GameDetailView.swift` — drill-in view with prediction (pick, confidence bar, key factor chips), venue, weather, and spread
- `Services/APIService.swift` — single `@MainActor` class with `URLSession` async/await calls to the API
- `Models/Game.swift` — `Codable` structs mirroring API response shapes (`NextGame`, `NextGamesResponse`, `VenueDetail`, `WeatherDetail`, `LinesDetail`, `PredictionDetail`)

## Key notes

- Teams list is loaded from a bundled JSON file (`fbs_teams.json` in Resources), not fetched from the API
- `DashboardView.formatDate()` formats the ISO date string from the API
- The API base URL is hardcoded in `APIService.swift` as `http://localhost:8000/v1` — no production URL yet
- Selected team IDs are stored as `Set<Int>` in `TeamListVM`; persistence mechanism not yet implemented (resets on app restart)

## Next steps (from README)

- Display list of weekly games for all hated teams with spreads, predictions, and probabilities
- Persist selected teams across app launches (UserDefaults)

## Related projects

- `../cfb-ats-api` — backend; run locally before launching the app; `/v1/teams/next-game` returns predictions
- `../cfb-ats-data` — produces the ML model that powers predictions
