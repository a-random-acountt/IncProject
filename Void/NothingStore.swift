import Foundation

class NothingStore: ObservableObject {
    @Published var events: [NothingEvent]
    @Published var stats: NothingStats

    private let calendar: Calendar
    private let defaultsKey = "void.nothingEvents.v1"

    init(events: [NothingEvent] = NothingStore.loadEvents(), asOf referenceDate: Date = .now, calendar: Calendar = .current) {
        self.events = events
        self.calendar = calendar
        self.stats = NothingStats.compute(from: events, asOf: referenceDate, calendar: calendar)
    }

    func logNothing(at date: Date = .now) {
        events.append(NothingEvent(date: date))
        stats = NothingStats.compute(from: events, asOf: date, calendar: calendar)
        saveEvents()
    }

    func reset(asOf date: Date = .now) {
        events = []
        stats = NothingStats.compute(from: events, asOf: date, calendar: calendar)
        saveEvents()
    }

    func refreshStats(asOf date: Date = .now) {
        stats = NothingStats.compute(from: events, asOf: date, calendar: calendar)
    }

    private func saveEvents() {
        if let data = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    private static func loadEvents() -> [NothingEvent] {
        guard let data = UserDefaults.standard.data(forKey: "void.nothingEvents.v1"),
              let saved = try? JSONDecoder().decode([NothingEvent].self, from: data) else {
            return []
        }
        return saved
    }
}
