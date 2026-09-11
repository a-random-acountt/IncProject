import Foundation

/// A snapshot of everything Void knows about your commitment to inactivity,
/// derived from the raw event log. Kept as a plain value type so views can
/// diff it cheaply and tests can construct it without a store.
public struct NothingStats: Equatable, Sendable {
    public let totalClicks: Int
    public let todayClicks: Int
    public let currentStreak: Int
    public let longestStreak: Int
    /// Oldest first, always exactly `trailingDays` entries, zero-filled.
    public let dailyCounts: [(day: Date, count: Int)]
    /// Count per flavor, in `NothingFlavor.allCases` order.
    public let flavorCounts: [NothingFlavor: Int]

    public static func == (lhs: NothingStats, rhs: NothingStats) -> Bool {
        lhs.totalClicks == rhs.totalClicks
            && lhs.todayClicks == rhs.todayClicks
            && lhs.currentStreak == rhs.currentStreak
            && lhs.longestStreak == rhs.longestStreak
            && lhs.dailyCounts.map(\.count) == rhs.dailyCounts.map(\.count)
            && lhs.dailyCounts.map(\.day) == rhs.dailyCounts.map(\.day)
            && lhs.flavorCounts == rhs.flavorCounts
    }

    public init(
        totalClicks: Int,
        todayClicks: Int,
        currentStreak: Int,
        longestStreak: Int,
        dailyCounts: [(day: Date, count: Int)],
        flavorCounts: [NothingFlavor: Int]
    ) {
        self.totalClicks = totalClicks
        self.todayClicks = todayClicks
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.dailyCounts = dailyCounts
        self.flavorCounts = flavorCounts
    }

    /// Computes a full stats snapshot from a raw event log.
    public static func compute(
        from events: [NothingEvent],
        asOf referenceDate: Date = .now,
        trailingDays: Int = 14,
        calendar: Calendar = .current
    ) -> NothingStats {
        let dates = events.map(\.date)
        let today = calendar.startOfDay(for: referenceDate)
        let todayCount = dates.filter { calendar.isDate($0, inSameDayAs: today) }.count

        var flavorCounts: [NothingFlavor: Int] = [:]
        for flavor in NothingFlavor.allCases { flavorCounts[flavor] = 0 }
        for event in events {
            flavorCounts[event.flavor(calendar: calendar), default: 0] += 1
        }

        return NothingStats(
            totalClicks: events.count,
            todayClicks: todayCount,
            currentStreak: Streaks.current(for: dates, asOf: referenceDate, calendar: calendar),
            longestStreak: Streaks.longest(for: dates, calendar: calendar),
            dailyCounts: Streaks.dailyCounts(for: dates, trailingDays: trailingDays, asOf: referenceDate, calendar: calendar),
            flavorCounts: flavorCounts
        )
    }

    /// An empty snapshot, used before the store has loaded anything.
    public static func empty(trailingDays: Int = 14, asOf referenceDate: Date = .now, calendar: Calendar = .current) -> NothingStats {
        compute(from: [], asOf: referenceDate, trailingDays: trailingDays, calendar: calendar)
    }
}
