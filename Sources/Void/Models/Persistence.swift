import Foundation
import VoidCore

/// Wires a `NothingStore` up to `UserDefaults` so history survives a
/// relaunch. `VoidCore` itself stays persistence-agnostic; this is the one
/// place that knows *where* the events live.
enum PersistentNothingStore {
    private static let defaultsKey = "void.nothingEvents.v1"

    static func makeStore(userDefaults: UserDefaults = .standard) -> NothingStore {
        NothingStore(events: loadEvents(from: userDefaults)) { events in
            save(events, to: userDefaults)
        }
    }

    private static func loadEvents(from defaults: UserDefaults) -> [NothingEvent] {
        guard let data = defaults.data(forKey: defaultsKey) else { return [] }
        return (try? JSONDecoder().decode([NothingEvent].self, from: data)) ?? []
    }

    private static func save(_ events: [NothingEvent], to defaults: UserDefaults) {
        guard let data = try? JSONEncoder().encode(events) else { return }
        defaults.set(data, forKey: defaultsKey)
    }
}
