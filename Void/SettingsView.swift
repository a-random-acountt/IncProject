import SwiftUI

struct SettingsView: View {
    let store: NothingStore

    @AppStorage("void.soundEnabled") private var soundEnabled: Bool = true
    @State private var isShowingResetConfirmation = false

    var body: some View {
        Form {
            Section {
                Toggle("Sound effects", isOn: $soundEnabled)
            } header: {
                Text("Feedback")
            } footer: {
                Text("Plays a satisfying click that accomplishes nothing.")
            }

            Section {
                Button("Reset all progress", role: .destructive) {
                    isShowingResetConfirmation = true
                }
            } header: {
                Text("Danger zone")
            } footer: {
                Text("Deletes your entire history of nothing. There is no undo, fittingly.")
            }

            Section("About") {
                LabeledContent("Version", value: "1.0.0")
                LabeledContent("Total clicks", value: CompactNumber.format(store.stats.totalClicks))
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Settings")
        .confirmationDialog(
            "Reset all progress?",
            isPresented: $isShowingResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset Everything", role: .destructive) {
                store.reset()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently deletes your click history and streaks.")
        }
    }
}
