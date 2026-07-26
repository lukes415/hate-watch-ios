import SwiftUI
import Combine

@MainActor
final class TeamListVM: ObservableObject {
    @Published var teams: [Team] = []
    @Published var search = ""
    @Published var selectedTeams: Set<Int> = []

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
    
    func toggleSelection(for team: Team) {
        if selectedTeams.contains(team.id) {
            selectedTeams.remove(team.id)
        } else {
            selectedTeams.insert(team.id)
        }
    }
}

struct TeamRow: View {
    let team: Team
    let isSelected: Bool
    let onTap: () -> Void
    
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
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
            }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

struct TeamListView: View {
    @StateObject private var vm = TeamListVM()
    @State private var showDashboard = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List(vm.filtered) { team in
                    TeamRow(
                        team: team,
                        isSelected: vm.selectedTeams.contains(team.id),
                        onTap: { vm.toggleSelection(for: team) }
                    )
                }
                .listStyle(.insetGrouped)
                .searchable(text: $vm.search, placement: .navigationBarDrawer(displayMode: .always))

                if !vm.selectedTeams.isEmpty {
                    continueBar
                }
            }
            .navigationTitle("Teams to Track")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showDashboard = true
                    }
                    .disabled(vm.selectedTeams.isEmpty)
                }
            }
            .navigationDestination(isPresented: $showDashboard) {
                DashboardView(
                    selectedTeamIds: vm.selectedTeams,
                    allTeams: vm.teams
                )
            }
        }
    }

    // Stays visible regardless of search-focus state, unlike the toolbar's Done
    // button which SwiftUI hides while .searchable is active. This is the only
    // way to confirm a selection made while search is focused (e.g. searching
    // by conference) without first dismissing search.
    private var continueBar: some View {
        Button {
            showDashboard = true
        } label: {
            Text("\(vm.selectedTeams.count) team\(vm.selectedTeams.count == 1 ? "" : "s") selected → Continue")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
        }
    }
}

//#Preview { TeamListView() }
