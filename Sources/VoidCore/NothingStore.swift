import Foundation
import Observation

/// The single source of truth for a user's commitment to nothing.
///
/// This is plain `Observation`/Foundation - no SwiftUI, AppKit, or UIKit -
/// so it can be driven directly by SwiftUI views via `@Bindable`/property
/// access, and exercised with plain unit tests on any platform.
///
/// Persistence is intentionally *not* built in: the app layer supplies a
/// `persist` closure (writing to `UserDefaults`, a file, wherever) and an
/// initial `events` array (read back at launch). That keeps this type
/// trivially testable in-memory.
@Observable
public final class NothingStore {
    public private(set) var events: [NothingEvent]
    public private(set) var stats: NothingStats

    private let calendar: Calendar
    private let trailingDays: Int
    private let persist: (([NothingEvent]) -> Void)?

    public init(
        events: [NothingEvent] = [],
        asOf referenceDate: Date = .now,
        calendar: Calendar = .current,
        trailingDays: Int = 14,
        persist: (([NothingEvent]) -> Void)? = nil
    ) {
        self.events = events
        self.calendar = calendar
        self.trailingDays = trailingDays
        self.persist = persist
        self.stats = NothingStats.compute(from: events, asOf: referenceDate, trailingDays: trailingDays, calendar: calendar)
    }

    /// Logs one instance of nothing. Returns any achievements newly unlocked
    /// by this click, so the UI can celebrate them.
    @discardableResult
    public func logNothing(at date: Date = .now) -> [Achievement] {
        let before = stats
        events.append(NothingEvent(date: date))
        recompute(asOf: date)
        persist?(events)

        return AchievementCatalog.newlyUnlocked(
            previousTotalClicks: before.totalClicks,
            previousLongestStreak: before.longestStreak,
            newTotalClicks: stats.totalClicks,
            newLongestStreak: stats.longestStreak
        )
    }

    /// Wipes the entire history. There is a confirmation dialog between the
    /// user and this method; it does not ask twice.
    public func reset(asOf date: Date = .now) {
        events = []
        recompute(asOf: date)
        persist?(events)
    }

    /// Recomputes derived stats against a fresh reference date, without
    /// adding an event - call this when the app becomes active again, in
    /// case a day boundary was crossed while it was backgrounded.
    public func refreshStats(asOf date: Date = .now) {
        recompute(asOf: date)
    }

    private func recompute(asOf date: Date) {
        stats = NothingStats.compute(from: events, asOf: date, trailingDays: trailingDays, calendar: calendar)
    }
}
