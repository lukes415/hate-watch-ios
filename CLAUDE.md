# hate-watch-ios

SwiftUI iOS app for tracking upcoming games of your most-hated college football teams. Connects to `cfb-ats-api` for live game data.

## Running

Open `HateWatch.xcodeproj` in Xcode and run on simulator or device. The app expects `cfb-ats-api` running locally at `http://localhost:8000`.

## Architecture

- `Views/TeamListView.swift` — team browser with search; loads teams from bundled `fbs_teams.json`; persists selected team IDs
- `Views/DashboardView.swift` — shows next upcoming game card for each selected team; calls `/v1/teams/next-games`
- `Views/GameCardView.swift` — reusable card component
- `Views/GameDetailView.swift` — drill-in view for individual game details
- `Services/APIService.swift` — single `@MainActor` class with `URLSession` async/await calls to the API
- `Models/` — `Codable` structs mirroring API response shapes (`Team`, `NextGame`, `NextGamesResponse`)

## Key notes

- Teams list is loaded from a bundled JSON file (`fbs_teams.json` in Resources), not fetched from the API
- `DashboardView.formatDate()` is a stub — ISO date string is returned as-is; formatting is a TODO
- The API base URL is hardcoded in `APIService.swift` as `http://localhost:8000/v1` — no production URL yet
- Selected team IDs are stored as `Set<Int>` in `TeamListVM`; persistence mechanism not yet implemented (resets on app restart)

## Next steps (from README)

- Fetch ATS predictions from `cfb-ats-api` and display on game cards
- Show spread + model probability per game
- Drill-in view showing feature importances / what the model considered
- Persist selected teams across app launches (UserDefaults)

## Related projects

- `../cfb-ats-api` — backend; run locally before launching the app
- `../cfb-ats-data` — produces the ML model that will eventually power predictions
