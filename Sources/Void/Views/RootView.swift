import SwiftUI
import VoidCore

struct RootView: View {
    var store: NothingStore

    @State private var selection: AppSection = .home
    @State private var isShowingCommandPalette = false
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                LaunchSplashView()
            } else {
                TabView(selection: $selection) {
                    Tab("Home", systemImage: AppSection.home.symbolName, value: AppSection.home) {
                        tab(for: .home) { DashboardView(store: store) }
                    }
                    Tab("Analytics", systemImage: AppSection.analytics.symbolName, value: AppSection.analytics) {
                        tab(for: .analytics) { AnalyticsView(store: store) }
                    }
                    Tab("Achievements", systemImage: AppSection.achievements.symbolName, value: AppSection.achievements) {
                        tab(for: .achievements) { AchievementsView(store: store) }
                    }
                    Tab("History", systemImage: AppSection.history.symbolName, value: AppSection.history) {
                        tab(for: .history) { HistoryView(store: store) }
                    }
                    Tab("Settings", systemImage: AppSection.settings.symbolName, value: AppSection.settings) {
                        tab(for: .settings) { SettingsView(store: store) }
                    }
                }
                .tint(.accentColor)
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

    /// Wraps a tab's root screen in its own NavigationStack (so each tab
    /// keeps its own navigation history) plus a toolbar button that opens
    /// the command palette for anyone without a hardware keyboard.
    @ViewBuilder
    private func tab(for section: AppSection, @ViewBuilder content: () -> some View) -> some View {
        NavigationStack {
            content()
                .navigationTitle(section.title)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingCommandPalette = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                        }
                        .accessibilityLabel("Search commands")
                    }
                }
        }
    }

    /// An invisible button whose only purpose is to own the ⌘K shortcut so
    /// it works from any tab when a hardware keyboard is attached.
    private var commandPaletteShortcut: some View {
        Button("Command Palette") { isShowingCommandPalette = true }
            .keyboardShortcut("k", modifiers: .command)
            .opacity(0)
            .frame(width: 0, height: 0)
            .accessibilityHidden(true)
    }
}
