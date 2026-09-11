import Testing
import Foundation
@testable import VoidCore

private func utcCalendar() -> Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    return calendar
}

private func date(_ year: Int, _ month: Int, _ day: Int, hour: Int = 12, calendar: Calendar) -> Date {
    calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour))!
}

@Suite("Streaks")
struct StreaksTests {
    @Test("No events means no streak")
    func emptyStreak() {
        let calendar = utcCalendar()
        let now = date(2026, 9, 11, calendar: calendar)
        #expect(Streaks.current(for: [], asOf: now, calendar: calendar) == 0)
        #expect(Streaks.longest(for: [], calendar: calendar) == 0)
    }

    @Test("Consecutive days count as a streak, a gap breaks it")
    func consecutiveDaysStreak() {
        let calendar = utcCalendar()
        let now = date(2026, 9, 11, calendar: calendar)
        let dates = [
            date(2026, 9, 9, calendar: calendar),
            date(2026, 9, 10, calendar: calendar),
            now,
        ]
        #expect(Streaks.current(for: dates, asOf: now, calendar: calendar) == 3)

        let withGap = dates + [date(2026, 9, 5, calendar: calendar)]
        #expect(Streaks.current(for: withGap, asOf: now, calendar: calendar) == 3)
    }

    @Test("No event today means the current streak is zero even with history")
    func missingTodayBreaksCurrentStreak() {
        let calendar = utcCalendar()
        let now = date(2026, 9, 11, calendar: calendar)
        let dates = [
            date(2026, 9, 9, calendar: calendar),
            date(2026, 9, 10, calendar: calendar),
        ]
        #expect(Streaks.current(for: dates, asOf: now, calendar: calendar) == 0)
    }

    @Test("Multiple clicks on the same day only count once toward the streak")
    func sameDayDoesNotInflateStreak() {
        let calendar = utcCalendar()
        let now = date(2026, 9, 11, hour: 9, calendar: calendar)
        let dates = [
            date(2026, 9, 11, hour: 8, calendar: calendar),
            date(2026, 9, 11, hour: 20, calendar: calendar),
            date(2026, 9, 11, hour: 23, calendar: calendar),
        ]
        #expect(Streaks.current(for: dates, asOf: now, calendar: calendar) == 1)
    }

    @Test("Longest streak finds the best historical run, not just the current one")
    func longestStreakFindsBestRun() {
        let calendar = utcCalendar()
        let dates = [
            date(2026, 8, 1, calendar: calendar),
            date(2026, 8, 2, calendar: calendar),
            date(2026, 8, 3, calendar: calendar),
            date(2026, 8, 4, calendar: calendar),
            date(2026, 8, 4, hour: 22, calendar: calendar),
            // gap
            date(2026, 9, 10, calendar: calendar),
            date(2026, 9, 11, calendar: calendar),
        ]
        #expect(Streaks.longest(for: dates, calendar: calendar) == 4)
    }

    @Test("Daily counts are zero-filled and cover exactly the trailing window")
    func dailyCountsAreZeroFilled() {
        let calendar = utcCalendar()
        let now = date(2026, 9, 11, calendar: calendar)
        let dates = [
            date(2026, 9, 11, calendar: calendar),
            date(2026, 9, 11, hour: 18, calendar: calendar),
            date(2026, 9, 9, calendar: calendar),
        ]
        let counts = Streaks.dailyCounts(for: dates, trailingDays: 5, asOf: now, calendar: calendar)
        #expect(counts.count == 5)
        #expect(counts.last?.count == 2)
        #expect(counts.first?.count == 0)
        let sept9 = counts.first { calendar.isDate($0.day, inSameDayAs: date(2026, 9, 9, calendar: calendar)) }
        #expect(sept9?.count == 1)
    }
}
