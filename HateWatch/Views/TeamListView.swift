import SwiftUI
import Combine

@MainActor
final class TeamListVM: ObservableObject {
    @Published var teams: [Team] = []
    @Published var search = ""

    init() { load() }

    private func load() {
        guard let url = Bundle.main.url(forResource: "fbs_teams", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let list = try? JSONDecoder().decode([Team].self, from: data) else {
            print("teams.json not found/decoding failed"); return
        }
        teams = list
    }

    var filtered: [Team] {
        guard !search.isEmpty else { return teams }
        let q = search.lowercased()
        return teams.filter { $0.name.lowercased().contains(q) || ($0.conference?.lowercased().contains(q) ?? false) }
    }
}

struct TeamRow: View {
    let team: Team
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: team.logoURL) { img in
                img.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 44, height: 44)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(team.name).font(.headline)
                if let conf = team.conference { Text(conf).font(.subheadline).foregroundStyle(.secondary) }
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

struct TeamListView: View {
    @StateObject private var vm = TeamListVM()
    var body: some View {
        NavigationStack {
            List(vm.filtered) { team in TeamRow(team: team) }
                .listStyle(.insetGrouped)
                .navigationTitle("Teams to Track")
                .searchable(text: $vm.search, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}

#Preview { TeamListView() }
