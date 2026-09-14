import SwiftUI

@main
struct VoidApp: App {
    @StateObject private var store = NothingStore()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
                .preferredColorScheme(.dark)
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        store.refreshStats()
                    }
                }
        }
    }
}
