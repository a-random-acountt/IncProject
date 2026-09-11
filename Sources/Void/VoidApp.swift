import SwiftUI
import VoidCore

@main
struct VoidApp: App {
    @State private var store = PersistentNothingStore.makeStore()
    @AppStorage("void.theme") private var themeRawValue: String = AppTheme.system.rawValue
    @Environment(\.scenePhase) private var scenePhase

    private var colorScheme: ColorScheme? {
        (AppTheme(rawValue: themeRawValue) ?? .system).colorScheme
    }

    var body: some Scene {
        WindowGroup {
            RootView(store: store)
                .preferredColorScheme(colorScheme)
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        store.refreshStats()
                    }
                }
        }
        #if os(macOS)
        .defaultSize(width: 980, height: 680)
        #endif
    }
}
