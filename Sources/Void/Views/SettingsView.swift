import SwiftUI
import VoidCore

struct SettingsView: View {
    var store: NothingStore

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

            Section("Keyboard shortcuts") {
                shortcutRow("⌘K", "Open the command palette")
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
                LabeledContent("Version", value: "1.6.0")
                LabeledContent("Total clicks", value: CompactNumber.format(store.stats.totalClicks))
                NavigationLink("Changelog") {
                    ChangelogView()
                }
            }
        }
        .formStyle(.grouped)
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
            Text("This permanently deletes your click history, streaks, and achievements.")
        }
    }

    private func shortcutRow(_ key: String, _ description: String) -> some View {
        HStack {
            Text(description)
            Spacer()
            Text(key)
                .monospacedLabel(13, weight: .semibold)
                .padding(.horizontal, Metrics.spacingSM)
                .padding(.vertical, 2)
                .background(Color.appBackground)
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .strokeBorder(Color.appBorder, lineWidth: Metrics.hairline)
                )
        }
    }
}
