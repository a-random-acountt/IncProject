import Foundation

struct NothingStats: Equatable, Sendable {
    let totalClicks: Int
    let todayClicks: Int
    let currentStreak: Int
    let longestStreak: Int

    static func compute(
        from events: [NothingEvent],
        asOf referenceDate: Date = .now,
        calendar: Calendar = .current
    ) -> NothingStats {
        let dates = events.map(\.date)
        let today = calendar.startOfDay(for: referenceDate)
        let todayCount = dates.filter { calendar.isDate($0, inSameDayAs: today) }.count

        return NothingStats(
            totalClicks: events.count,
            todayClicks: todayCount,
            currentStreak: Streaks.current(for: dates, asOf: referenceDate, calendar: calendar),
            longestStreak: Streaks.longest(for: dates, calendar: calendar)
        )
    }

    static func empty(asOf referenceDate: Date = .now, calendar: Calendar = .current) -> NothingStats {
        compute(from: [], asOf: referenceDate, calendar: calendar)
    }
}
