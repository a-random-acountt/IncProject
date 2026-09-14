import SwiftUI

struct ContentView: View {
    @ObservedObject var store: NothingStore

    var body: some View {
        NavigationStack {
            DashboardScreen(store: store)
                .navigationTitle("Void")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingsScreen(store: store)
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
        }
    }
}

private struct DashboardScreen: View {
    @ObservedObject var store: NothingStore
    @State private var toast: ToastMessage?

    private let confirmations = [
        "Nothing happened.",
        "Still nothing.",
        "As expected: nothing.",
        "Confirmed: nothing.",
        "Nothing, again.",
        "Zero side effects.",
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting)
                        .font(.system(size: 26, weight: .bold))
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Your dashboard for accomplishing exactly nothing.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                NothingButton(action: logNothing)
                    .padding(.vertical, 12)

                statGrid
            }
            .padding(32)
            .frame(maxWidth: 640)
            .frame(maxWidth: .infinity)
        }
        .background(Color(.systemBackground))
        .toast($toast)
    }

    private var statGrid: some View {
        HStack(spacing: 12) {
            StatTile(
                label: "Total nothing",
                value: "\(store.stats.totalClicks)",
                symbolName: "circle.dashed"
            )
            StatTile(
                label: "Current streak",
                value: "\(store.stats.currentStreak)d",
                caption: store.stats.currentStreak == 0 ? "Start one today." : nil,
                symbolName: "flame"
            )
        }
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: return "Good morning. Ready to accomplish nothing?"
        case 12..<18: return "Good afternoon. Still nothing on the agenda?"
        default: return "Good evening. Perfect time for nothing."
        }
    }

    private func logNothing() {
        store.logNothing()
        toast = ToastMessage(text: confirmations.randomElement() ?? "Nothing happened.", symbolName: "checkmark.circle")
    }
}

private struct SettingsScreen: View {
    @ObservedObject var store: NothingStore
    @State private var isShowingResetConfirmation = false

    var body: some View {
        Form {
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
                LabeledContent("Total clicks", value: "\(store.stats.totalClicks)")
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

private struct PressScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

private struct NothingButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.white)
                VStack(spacing: 4) {
                    Image(systemName: "circle.dashed")
                        .font(.system(size: 30, weight: .medium))
                    Text("Do Nothing")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundStyle(.black)
            }
            .frame(width: 176, height: 176)
        }
        .buttonStyle(PressScaleButtonStyle())
    }
}

private struct StatTile: View {
    let label: String
    let value: String
    var caption: String? = nil
    var symbolName: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                if let symbolName {
                    Image(systemName: symbolName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                }
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(.primary)
            if let caption {
                Text(caption)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(Color(.separator), lineWidth: 1)
        )
    }
}

struct ToastMessage: Equatable, Identifiable {
    let id = UUID()
    let text: String
    let symbolName: String

    static func == (lhs: ToastMessage, rhs: ToastMessage) -> Bool { lhs.id == rhs.id }
}

private struct ToastOverlay: View {
    let message: ToastMessage

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: message.symbolName)
            Text(message.text)
                .font(.subheadline.weight(.medium))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .glassEffect(in: Capsule())
        .shadow(color: .black.opacity(0.35), radius: 16, y: 6)
    }
}

private struct ToastModifier: ViewModifier {
    @Binding var message: ToastMessage?

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let message {
                    ToastOverlay(message: message)
                        .padding(.bottom, 32)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .task(id: message.id) {
                            try? await Task.sleep(for: .seconds(2.2))
                            if self.message?.id == message.id {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    self.message = nil
                                }
                            }
                        }
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: message)
    }
}

extension View {
    func toast(_ message: Binding<ToastMessage?>) -> some View {
        modifier(ToastModifier(message: message))
    }
}
