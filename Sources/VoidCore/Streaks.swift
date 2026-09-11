import Foundation

/// Pure streak math over a set of event dates. Kept free of any stored
/// state so it is trivial to test with fixed calendars and reference dates.
public enum Streaks {

    /// The number of consecutive days, ending on `referenceDate`'s day, that
    /// contain at least one event. Returns 0 if there is no event today.
    public static func current(
        for dates: [Date],
        asOf referenceDate: Date,
        calendar: Calendar = .current
    ) -> Int {
        let days = Set(dates.map { calendar.startOfDay(for: $0) })
        var streak = 0
        var cursor = calendar.startOfDay(for: referenceDate)
        while days.contains(cursor) {
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: cursor) else {
                break
            }
            cursor = previousDay
        }
        return streak
    }

    /// The longest run of consecutive days (each containing at least one
    /// event) across the entire history.
    public static func longest(for dates: [Date], calendar: Calendar = .current) -> Int {
        guard !dates.isEmpty else { return 0 }
        let days = Set(dates.map { calendar.startOfDay(for: $0) }).sorted()

        var longest = 1
        var running = 1
        for index in 1..<days.count {
            let previous = days[index - 1]
            let day = days[index]
            if let expected = calendar.date(byAdding: .day, value: 1, to: previous),
               calendar.isDate(expected, inSameDayAs: day) {
                running += 1
            } else {
                running = 1
            }
            longest = max(longest, running)
        }
        return longest
    }

    /// Per-day counts for the trailing `days` days (inclusive of today),
    /// oldest first, with zero-filled gaps. Handy for feeding a bar/line chart
    /// that must show a continuous axis even on days nothing was logged.
    public static func dailyCounts(
        for dates: [Date],
        trailingDays days: Int,
        asOf referenceDate: Date,
        calendar: Calendar = .current
    ) -> [(day: Date, count: Int)] {
        guard days > 0 else { return [] }
        let today = calendar.startOfDay(for: referenceDate)
        var counts: [Date: Int] = [:]
        for date in dates {
            let day = calendar.startOfDay(for: date)
            counts[day, default: 0] += 1
        }

        var result: [(day: Date, count: Int)] = []
        for offset in stride(from: days - 1, through: 0, by: -1) {
            guard let day = calendar.date(byAdding: .day, value: -offset, to: today) else { continue }
            result.append((day: day, count: counts[day] ?? 0))
        }
        return result
    }
}
