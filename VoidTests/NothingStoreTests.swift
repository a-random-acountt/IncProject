import Testing
import Foundation
@testable import Void

@Suite("NothingStore")
struct NothingStoreTests {
    @Test("Starts empty with zeroed stats")
    func startsEmpty() {
        let store = NothingStore()
        #expect(store.events.isEmpty)
        #expect(store.stats.totalClicks == 0)
        #expect(store.stats.currentStreak == 0)
    }

    @Test("Logging nothing appends an event and updates stats immediately")
    func loggingUpdatesStats() {
        let calendar = utcCalendar()
        let now = date(2026, 9, 11, calendar: calendar)
        let store = NothingStore(calendar: calendar)
        store.logNothing(at: now)
        #expect(store.events.count == 1)
        #expect(store.stats.totalClicks == 1)
        #expect(store.stats.todayClicks == 1)
        #expect(store.stats.currentStreak == 1)
    }

    @Test("Persist callback receives the full event log on every mutation")
    func persistCallbackFires() {
        let calendar = utcCalendar()
        var persistedCounts: [Int] = []
        let store = NothingStore(calendar: calendar) { events in
            persistedCounts.append(events.count)
        }

        store.logNothing(at: date(2026, 9, 11, calendar: calendar))
        store.logNothing(at: date(2026, 9, 11, hour: 14, calendar: calendar))
        store.reset()

        #expect(persistedCounts == [1, 2, 0])
    }

    @Test("Reset clears history and stats")
    func resetClearsEverything() {
        let calendar = utcCalendar()
        let store = NothingStore(calendar: calendar)
        store.logNothing(at: date(2026, 9, 11, calendar: calendar))
        store.reset(asOf: date(2026, 9, 11, calendar: calendar))
        #expect(store.events.isEmpty)
        #expect(store.stats.totalClicks == 0)
        #expect(store.stats.currentStreak == 0)
    }

    @Test("Restoring a store from saved events reproduces the same stats")
    func rehydratesFromSavedEvents() {
        let calendar = utcCalendar()
        let savedEvents = [
            NothingEvent(date: date(2026, 9, 9, calendar: calendar)),
            NothingEvent(date: date(2026, 9, 10, calendar: calendar)),
            NothingEvent(date: date(2026, 9, 11, calendar: calendar)),
        ]
        let store = NothingStore(events: savedEvents, asOf: date(2026, 9, 11, calendar: calendar), calendar: calendar)
        #expect(store.stats.totalClicks == 3)
        #expect(store.stats.currentStreak == 3)
    }
}
