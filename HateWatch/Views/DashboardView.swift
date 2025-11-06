import SwiftUI

struct DashboardView: View {
    let selectedTeamIds: Set<Int>
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Dashboard")
                    .font(.largeTitle)
                
                Text("Selected \(selectedTeamIds.count) teams")
                    .foregroundStyle(.secondary)
                
                // Next step: add game cards here
                
                Spacer()
            }
            .navigationTitle("My Teams")
        }
    }
}

#Preview {
    DashboardView(selectedTeamIds: [1, 2])
}
