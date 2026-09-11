import SwiftUI
import VoidCore

@main
struct VoidApp: App {
    @State private var store = PersistentNothingStore.makeStore()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView(store: store)
                .preferredColorScheme(.dark)
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        store.refreshStats()
                    }
                }
        }
    }
}
