import SwiftUI
import VoidCore

struct SettingsView: View {
    var store: NothingStore

    @AppStorage("void.theme") private var themeRawValue: String = AppTheme.system.rawValue
    @AppStorage("void.soundEnabled") private var soundEnabled: Bool = true
    @State private var isShowingResetConfirmation = false

    private var theme: Binding<AppTheme> {
        Binding(
            get: { AppTheme(rawValue: themeRawValue) ?? .system },
            set: { themeRawValue = $0.rawValue }
        )
    }

    var body: some View {
        Form {
            Section("Appearance") {
                Picker("Theme", selection: theme) {
                    ForEach(AppTheme.allCases) { option in
                        Label(option.label, systemImage: option.symbolName).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section {
                Toggle("Sound effects", isOn: $soundEnabled)
            } header: {
                Text("Feedback")
            } footer: {
                Text("Plays a satisfying click that accomplishes nothing.")
            }

            Section("Keyboard shortcuts") {
                shortcutRow("⌘K", "Open the command palette")
                shortcutRow("1–6", "Jump to a section")
                shortcutRow("⌘,", "Open Settings")
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
