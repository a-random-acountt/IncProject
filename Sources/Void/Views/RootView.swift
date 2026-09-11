import SwiftUI
import VoidCore

struct RootView: View {
    var store: NothingStore

    @State private var selection: AppSection? = .home
    @State private var isShowingCommandPalette = false
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                LaunchSplashView()
            } else {
                NavigationSplitView {
                    SidebarView(selection: $selection) {
                        isShowingCommandPalette = true
                    }
                } detail: {
                    NavigationStack {
                        detail
                            .navigationTitle((selection ?? .home).title)
                    }
                }
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(650))
            withAnimation(.easeInOut(duration: 0.3)) {
                isLoading = false
            }
        }
        .background(commandPaletteShortcut)
        .sheet(isPresented: $isShowingCommandPalette) {
            CommandPaletteView(store: store, selection: $selection)
        }
    }

    @ViewBuilder
    private var detail: some View {
        switch selection ?? .home {
        case .home: DashboardView(store: store)
        case .analytics: AnalyticsView(store: store)
        case .achievements: AchievementsView(store: store)
        case .history: HistoryView(store: store)
        case .changelog: ChangelogView()
        case .settings: SettingsView(store: store)
        }
    }

    /// An invisible button whose only purpose is to own the ⌘K shortcut so
    /// it works no matter which section currently has focus.
    private var commandPaletteShortcut: some View {
        Button("Command Palette") { isShowingCommandPalette = true }
            .keyboardShortcut("k", modifiers: .command)
            .opacity(0)
            .frame(width: 0, height: 0)
            .accessibilityHidden(true)
    }
}
