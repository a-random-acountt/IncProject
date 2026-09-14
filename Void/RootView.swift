import SwiftUI

struct RootView: View {
    let store: NothingStore

    var body: some View {
        NavigationStack {
            DashboardView(store: store)
                .navigationTitle("Void")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingsView(store: store)
                        } label: {
                            Image(systemName: "gearshape")
                        }
                        .accessibilityLabel("Settings")
                    }
                }
        }
    }
}
