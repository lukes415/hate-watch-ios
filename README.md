# Hate Watch iOS

> SwiftUI app to allow users to experience the joy of watching their most hated teams lose.

## Completed
- [x] Team list selector with team logos
- [x] Game cards showing game details such as home team, away team, and start time
- [x] Click-in to indivdual game details
- [x] Connection to cfb-ats-api to pull and display the next game for selected teams

## Next Steps
- [ ] Iterate on existing screens

## Goals
- [ ] Create simple design previews and add them to the README
- [x] Allow users to select the teams they want to hate watch
- [ ] Fetch predictions from `cfb-ats-api` to let users know whether the model thinks the team will cover
- [ ] Display list of weekly games for all hated teams with spreads, predictions, and probabilities.
- [ ] Allow users to drill in to see some of what the model is considering

## Tech
- Swift 5, SwiftUI
- URLSession (async/await)
- Codable structs for API schemas


## Views
### Selecting teams you want to track:

![list of teams](/resources/team_select.png)

### Game cards:

![game cards](/resources/game_cards.png)

### Game details:

![game details](/resources/game_details.png)